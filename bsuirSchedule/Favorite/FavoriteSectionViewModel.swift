//
//  FavoriteSectionViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 17.11.22.
//

import SwiftUI

class FavoriteSectionViewModel: ObservableObject {
    var lessonsSectioned: LessonsSectioned
    var lessonsViewModel: LessonsViewModel? = nil
    var nearestSection: LessonsSection? = nil
    var titleBase: String!
    
    @Published var favoriteSectionState: FavoriteSectionState = .updating
    
    @Published var lesson: Lesson?
    @Published var title: String
    
    
    init(lessonsSectioned: LessonsSectioned) {
        self.lessonsSectioned = lessonsSectioned
        if let group = lessonsSectioned as? Group {
            titleBase = group.id
        }
        if let employee = lessonsSectioned as? Employee {
            titleBase = employee.lastName
        }
        if let classroom = lessonsSectioned as? Classroom {
            titleBase = classroom.formattedName(showBuilding: true)
        }
        title = titleBase
        
        Task.init {
            await update()
        }
        
    }
    
    
    func update() async {
        let viewModel = LessonsViewModel(lessonsSectioned)
        
        
        await MainActor.run {
            lessonsViewModel = viewModel
        }
        
        
        nearestSection = lessonsViewModel!.element.nearestDateBasedSection
        if let currentLesson = await updateCurrentLesson() {
            await MainActor.run {
                self.lesson = currentLesson
                withAnimation {
                    self.favoriteSectionState = .nextLesson
                }
            }
        } else {
            await MainActor.run {
                self.favoriteSectionState = .noMoreLessons
            }
        }
        await updateTitle()
    }
    
    func description() -> String? {
        if let _ = lessonsSectioned.self as? Group {
            return nearestSection?.description(divideSubgroups: true)
        } else {
            return nearestSection?.description()
        }
    }
    
    func updateTitle() async {
        await MainActor.run {
            switch favoriteSectionState {
            case .updating:
                title = titleBase
            case .nextLesson:
                title = titleBase + ", " + nearestSection!.dateString!
            case .noMoreLessons:
                title = titleBase + ", занятий больше нет"
            }
            
        }
        //        let date = nearestSection!.date!
        //        let daysDifference = Date().removedTime().dateComponentsTo(date, .day)
        //        var dateString: String
        //
        //        if (-2...2).contains(daysDifference) {
        //            let relativeDateFormatter = RelativeDateTimeFormatter()
        //            relativeDateFormatter.locale = Locale(identifier: "ru_BY")
        //            relativeDateFormatter.dateTimeStyle = .named
        //            let dateComponents = DateComponents(day: daysDifference)
        //            dateString = relativeDateFormatter.localizedString(from: dateComponents)
        //        } else {
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.locale = Locale(identifier: "ru_BY")
        //            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        //            dateFormatter.dateFormat = "EEEEEE, d MMMM"
        //            dateString = dateFormatter.string(from: date)
        //        }
    }
    
    func updateCurrentLesson() async -> Lesson? {
        guard let section = nearestSection else { return nil}
        if section == lessonsViewModel!.todaySection {
            return section.nearestLesson()
        } else {
            return section.lessons.first
        }
    }
    
}
