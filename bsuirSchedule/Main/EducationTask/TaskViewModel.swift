////
////  TaskViewModel.swift
////  bsuirSchedule
////
////  Created by Andrej Hurynovič on 2.11.21.
////
//
//import SwiftUI
//
//class TaskViewModel: ObservableObject {
//
//    
//    var lesson: Lesson?
////    var nextSections: [ScheduleSection] = []
//
//    var task: EducationTask?
//
//    @Published var showDeadline = false
//    @Published var showLessonsPicker = true
//    @Published var showDatePicker = false
//    @Published var date = Date()
//
//    @Published var lessonsPickerValue = 0
//
//    @Published var text = ""
//
//    @Published var images: [UIImage] = []
//
////    func likeInit(lesson: Lesson, dateLessonsSections: [ScheduleSection]) {
//////        self.nextSections = lessonsSections
////        self.lesson = lesson
////
////        showDeadline = false
////        showLessonsPicker = true
////        showDatePicker = false
////        lessonsPickerValue = 0
////        onLessonsChange(0)
////        text = ""
////    }
//
//    convenience init(task: Hometask) {
//        self.init()
//        self.task = task
//
//        showDeadline = false
//        showLessonsPicker = false
//        showDatePicker = true
//        lessonsPickerValue = 0
//        date = task.deadline!
//        text = task.taskDescription!
//        images = imagesFromCoreData(object: task.photosData) ?? []
//    }
//
//    func lessonDescription() -> String {
//        if let lesson = lesson {
//            return lesson.abbreviation + " (\(lesson.oldLessonType.abbreviation)"
//        }
//
//        if let task = task {
//            return task.subject! + " (\(task.lessonType!))"
//        }
//
//        return ""
//    }
//
//    //MARK: - Deadline
//
//    func lessonsPickerRange() -> ClosedRange<Int> {
//        return 0...0
////        return 0...(nextSections.count - 1)
//    }
//
//    func deadlineDescription() -> String {
//        if showLessonsPicker {
//            return lessonsDescription()
//        } else {
//            return dateDescription()
//        }
//    }
//
//    func lessonsDescription() -> String {
//        switch lessonsPickerValue {
//        case 0: return "На следующую пару"
//        case 1: return "Через одну пару"
//        case 2: return "Через две пары"
//        case 3: return "Через три пары"
//        case 4: return "Через четыре пары"
//        case 5: return "Через пять пар"
//        case 6: return "Через шесть пар"
//        case 7: return "Через семь пар"
//        case 8: return "Через восемь пар"
//        case 9: return "Через девять пар"
//        default:
//            return dateDescription()
//        }
//    }
//
//    func dateDescription() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ru_BY")
//        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//        dateFormatter.dateFormat = "EEEEEE, d MMMM"
//
//        return dateFormatter.string(from: date)
//    }
//
////    func onLessonsChange(_ value: Int) {
////        date = nextSections[value].date
////        let time = nextSections[value].lessons.first(where: {lesson?.oldLessonType == $0.oldLessonType && lesson?.subject == $0.subject})?.timeRange().lowerBound
////        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time!)
////        date = Calendar.current.date(byAdding: .minute, value: dateComponents.minute!, to: date)!
////        date = Calendar.current.date(byAdding: .hour, value: dateComponents.hour!, to: date)!
//////        date.add
////    }
//
//    func onShowLessonsChange(_ value: Bool) {
//        if value {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.9)) {
//                showDatePicker = false
//            }
//        }
//    }
//
//    func onShowDatePickerChange(_ value: Bool) {
//        if value {
//            withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.9)) {
//                showLessonsPicker = false
//            }
//        }
//    }
//
//    func createTask() {
//        let task = Hometask(context: PersistenceController.shared.container.viewContext)
//        task.subject = lesson!.subject
//        task.lessonType = lesson?.oldLessonType.abbreviation
//        task.creation = Date()
//        task.deadline = date
//        task.taskDescription = text
//        task.photosData = coreDataObjectFromImages(images: self.images)
////        TaskStorage.shared.save()
//    }
//
//    func saveTask() {
//        task!.deadline = date
//        task!.taskDescription = text
//        task!.photosData = coreDataObjectFromImages(images: self.images)
////        TaskStorage.shared.save()
//    }
//
//    func coreDataObjectFromImages(images: [UIImage]) -> Data? {
//        let dataArray = NSMutableArray()
//
//        for img in images {
//            if let data = img.pngData() {
//                dataArray.add(data)
//            }
//        }
//
//        return try? NSKeyedArchiver.archivedData(withRootObject: dataArray, requiringSecureCoding: true)
//    }
//
//    func imagesFromCoreData(object: Data?) -> [UIImage]? {
//        var retVal = [UIImage]()
//
//        guard let object = object else { return nil }
//        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: object) {
//            for data in dataArray {
//                if let data = data as? Data, let image = UIImage(data: data) {
//                    retVal.append(image)
//                }
//            }
//        }
//
//        return retVal
//    }
//
//
//}
