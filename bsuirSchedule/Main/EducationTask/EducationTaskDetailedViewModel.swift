//
//  EducationTaskViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 2.11.21.
//

import CoreData
import SwiftUI
import PhotosUI
import Combine

class EducationTaskDetailedViewModel: ObservableObject {
    @Published var educationTask: EducationTask
    var backgroundContext: NSManagedObjectContext
    
    @Published var withDeadline = true
    @Published var deadline: Date = .now
    @Published var noteText: String = ""
    @Published var photosPickerItems: [PhotosPickerItem] = []
    @Published var imagesData: [Data] = []
    
    var lessons: Set<Lesson>?
    @Published var deadlineDates: [(title: String, date: Date)]?
    
    var cancelable: AnyCancellable?
    
    //add check is something changed
    //MARK: - Initialization
    
    init(educationTask: EducationTask) {
        self.backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        self.educationTask = backgroundContext.object(with: educationTask.objectID) as! EducationTask
        if let deadline = educationTask.deadline {
            withAnimation {
                self.deadline = deadline
            }
        } else {
            withDeadline = false
        }
        Task {
            await MainActor.run {
                withAnimation {
                    self.imagesData = educationTask.images ?? []
                }
            }
        }
        addPhotosPickerItemsSubscriber()
    }
    init(lesson: Lesson, lessons: any Sequence<Lesson>) {
        self.backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        self.educationTask = EducationTask(subject: lesson.abbreviation, context: backgroundContext)
        
        self.lessons = Set(lessons)
        createDeadlineDates()
        addPhotosPickerItemsSubscriber()
    }
    
    private func addPhotosPickerItemsSubscriber() {
        cancelable = $photosPickerItems
            .sink(receiveValue: { [weak self] items in
                guard let self = self, items.isEmpty == false else { return }
                Task {
                    await MainActor.run {
                        self.photosPickerItems.removeAll()
                    }
                    for item in items {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            await MainActor.run {
                                withAnimation {
                                    self.imagesData.append(data)
                                }
                            }
                        }
                    }
                }
            })
    }
    
    private func createDeadlineDates() {
        Task {
            guard let lessons = lessons else { return }
            var sections = await lessons.sections(.date, educationDates: lessons.dividedEducationDates?.nextDates)
            
            if sections.first?.isToday() == true {
                sections.removeFirst()
            }
            
            let deadlineDates =  sections.map { section in
                section.lessons.map { lesson in
                    let date = section.date!.assignedTime(from: lesson.timeRange.lowerBound)
                    let title = [lesson.type?.formattedName(abbreviated: true),
                                 lesson.subgroup != 0 ? "(\(String(lesson.subgroup))-я пд.)" : nil,
                                 date.formatted()]
                        .compactMap { $0 }
                        .joined(separator: ", ")
                    
                    return (title, date)
                }
                
            }
                .flatMap { $0 }
            
            await MainActor.run {
                withAnimation {
                    self.deadlineDates = deadlineDates
                }
            }
        }
    }
    
    //MARK: Methods
    
    public func save() {
        educationTask.deadline = self.withDeadline ? self.deadline : nil
        educationTask.note = self.noteText
        educationTask.images = self.imagesData
        
        try! backgroundContext.save()
    }
    
    
}
