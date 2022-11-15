//
//  LessonsViewModel.swift
//  LessonsViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
//import CoreData

class LessonsViewModel: ObservableObject {
    
    @Published var element: LessonsSectioned

    @Published var sections: [LessonsSection] = []
    @Published var nearestSection: LessonsSection? = nil
    @Published var currentDateSection: LessonsSection? = nil
    @Published var scrollTargetID: String? = nil
    @Published var representationMode: LessonsSectionRepresentationMode = .dateBased
    
    @Published var navigationViewTitle: String!
    
    //SearchField
    @Published var searchFieldFocusState = false
    @Published var showSearchField = false
    @Published var searchText = ""
    
    //DatePicker
    @Published var datePickerOffset = CGSize(width: 0, height: 0)
    @Published var showDatePicker = false
    @Published var datePickerDate = Date()
    
    //Toolbar
    @Published var showGroups = false
    @Published var showEmployees = false
    @Published var showWeeks = false
    
    @Published var showSubgroupPicker = false
    @Published var subgroup: Int? = nil
    
    init(_ element: LessonsSectioned) {
        self.element = element
        
        //                self.sections = element.dateBasedLessonsSections()
        //                currentTimeSection = nearestSection(to: Date())
        
        if let group = element as? Group {
            showSubgroupPicker = true
            navigationViewTitle = group.id
            showEmployees = true
        }
        
        if let employee = element as? Employee {
            navigationViewTitle = employee.lastName
            showGroups = true
        }
        
        if let classroom = element as? Classroom {
            navigationViewTitle = classroom.formattedName(showBuilding: true)
            showGroups = true
            showEmployees = true
        }
    }
    
    
    //Returns nearestSection to current time
    func nearestSection(to date: Date) -> LessonsSection? {
        switch representationMode {
        case .dateBased:
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
            return sections.first(where: { $0.date! >= date && ($0.nearestLesson() != nil) })
        case .weekBased:
            let week = date.educationWeek
            let weekday = date.weekDay()
            
            var filteredSections = sections
            filteredSections.removeAll { $0.week < week }
            filteredSections.removeAll { $0.weekday.rawValue < weekday.rawValue && $0.week == week }
            filteredSections.removeAll { $0.nearestLesson() == nil }
            
            guard filteredSections.isEmpty == false else {
                return sections.first
            }
            return filteredSections.first
        }

    }
    
    ///Returns section satisfied for provided date. Week-based sections works too.
    func dateSection(date: Date) -> LessonsSection? {
        switch representationMode {
        case .dateBased:
            let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
            return sections.first(where: { $0.date! == date })
        case .weekBased:
            let week = date.educationWeek
            let weekday = date.weekDay()
            
            return sections.first { $0.week == week && $0.weekday == weekday }
        }
    }
    
    ///Checks is provided section equal to pre-calculated today section
    func isToday(section: LessonsSection) -> Bool {
        guard let todaySection = currentDateSection else {
            return false
        }
        print(section == todaySection)
        return section == todaySection
    }
    
    func weekDay(date: Date) -> WeekDay {
        WeekDay(rawValue: Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1)))!
    }
    
    //MARK: ScrollViewProxy
    func scrollToID(_ ID: String?, in proxy: ScrollViewProxy) {
        if let ID = ID {
            withAnimation {
                proxy.scrollTo(ID, anchor: .top)
            }
        }
        scrollTargetID = nil
    }
    
    //MARK: Sections
    func updateSections() async {
        
        let lessonsSections: [LessonsSection]
        switch representationMode {
        case .dateBased:
            lessonsSections = await element.dateBasedLessonsSections(searchString: searchText, subgroup: subgroup)
            await MainActor.run {
                showWeeks = false
            }
        case .weekBased:
            lessonsSections = await element.weekBasedLessonsSections(searchString: searchText, subgroup: subgroup)
            await MainActor.run {
                showWeeks = true
            }
        }
        
        await MainActor.run {
            self.sections = lessonsSections
            self.nearestSection = nearestSection(to: Date())
            self.currentDateSection = dateSection(date: Date())
            
            self.scrollTargetID = nearestSection?.nearestLesson()?.id(sectionID: nearestSection!.id)
        }
    }
    
    //MARK: SearchField
    func searchFieldToggle() {
            if showSearchField {
                searchText = ""
                searchFieldFocusState = false
                UIApplication.shared.endEditing()
            } else {
                searchFieldFocusState = true
            }
            showSearchField.toggle()
    }
    
    //MARK: DatePicker
    func scrollToDate(_ date: Date) {
        scrollTargetID = nearestSection(to: date)?.id
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
            showDatePicker = false
        }
    }
    
    func onDatePickerGestureChanged(_ value: DragGesture.Value) {
        withAnimation {
            datePickerOffset.height = value.translation.height
        }
    }
    
    func onDatePickerGestureEnded(_ value: DragGesture.Value) {
        let height = value.translation.height
        if height > 100 {
            withAnimation(.spring()) {
                showDatePicker = false
                datePickerOffset.height = 0
                }

        } else {
            withAnimation(.spring()) {
                datePickerOffset.height = 0
            }
        }
    }
    
    //MARK: Toolbar
    var toolbarDefaultCriteria: Bool {
        
        switch representationMode {
        case .dateBased:
            if showWeeks {
                return false
            }
        case .weekBased:
            if !showWeeks {
                return false
            }
        }
        
        if self.representationMode == .weekBased && showWeeks || self.representationMode == .dateBased && !showWeeks {
            return true
        }
        
        switch element.self {
        case is Group:
            return showEmployees && !showGroups && !showWeeks && subgroup == nil
        case is Employee:
            return !showEmployees && showGroups && !showWeeks
        case is Classroom:
            return showEmployees == true && showGroups == true
        default:
            return false
        }
    }
    
}
