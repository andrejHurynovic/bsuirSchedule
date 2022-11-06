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
    @Published var currentTimeSection: LessonsSection? = nil
    @Published var targetSection: LessonsSection? = nil
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
            return sections.first(where: { $0.date! >= date })
        case .weekBased:
            let week = date.educationWeek
            let weekday = date.weekDay()
            
            var filteredSections = sections
            filteredSections.removeAll { $0.week < week }
            filteredSections.removeAll { $0.weekday.rawValue < weekday.rawValue && $0.week == week }
            
            guard filteredSections.isEmpty == false else {
                return sections.first
            }
            return filteredSections.first
        }

    }
    
    func weekDay(date: Date) -> WeekDay {
        WeekDay(rawValue: Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1)))!
    }
    
    //MARK: ScrollViewProxy
    func scrollToSection(_ section: LessonsSection?, in proxy: ScrollViewProxy) {
        if let section = section {
            withAnimation {
                proxy.scrollTo(section.id, anchor: .top)
            }
        }
        targetSection = nil
    }
    
    //MARK: Sections
    func updateSections() async {
        
        let lessonsSections: [LessonsSection]
        switch representationMode {
        case .dateBased:
            lessonsSections = await element.dateBasedLessonsSections(searchString: searchText, subgroup: subgroup)
        case .weekBased:
            lessonsSections = await element.weekBasedLessonsSections(searchString: searchText, subgroup: subgroup)
        }
        
        await MainActor.run {
            self.sections = lessonsSections
            currentTimeSection = nearestSection(to: Date())
            self.targetSection = currentTimeSection
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
        targetSection = nearestSection(to: date)
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
        switch element.self {
        case is Group:
            if showEmployees == true,
               showGroups == false,
               subgroup == nil {
                return true
            }
        case is Employee:
            if showEmployees == false,
               showGroups == true {
                return true
            }
        case is Classroom:
            if showEmployees == true,
               showGroups == true {
                return true
            }
        default:
            return false
        }
        return false
    }
    
}
