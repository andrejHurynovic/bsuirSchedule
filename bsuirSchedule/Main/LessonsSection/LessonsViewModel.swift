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
    @Published var shownSections: [LessonsSection] = []
    @Published var nearestSection: LessonsSection? = nil
    @Published var todaySection: LessonsSection? = nil
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
        
        //Sections
        self.sections = element.dateBasedLessonsSections
        nearestSection = element.nearestDateBasedSection
        todaySection = element.todayDateBasedSection
            
        if let group = element as? Group {
            showSubgroupPicker = true
            navigationViewTitle = group.id
            showEmployees = true
        }
        
        if let employee = element as? Employee {
            navigationViewTitle = employee.lastName
            showGroups = true
        }
        
        if let auditorium = element as? Auditorium {
            navigationViewTitle = auditorium.formattedName
            showGroups = true
            showEmployees = true
        }
    }
    
    func filteredSections(searchString: String, subgroup: Int?) -> [LessonsSection] {
        var filteredSections: [LessonsSection] = sections
        
        for index in filteredSections.indices {
            filteredSections[index].lessons.filter(abbreviation: searchString)
            filteredSections[index].lessons.filter(subgroup: subgroup)
        }
        
        filteredSections.removeAll { $0.lessons.isEmpty }
        return filteredSections
    }
    
    ///Checks is provided section equal to pre-calculated today section
    func isToday(section: LessonsSection) -> Bool {
        guard let todaySection = self.todaySection else {
            return false
        }
        return section == todaySection
    }
    
    func weekDay(date: Date) -> WeekDay {
        WeekDay(rawValue: Int16((Calendar(identifier: .iso8601).ordinality(of: .weekday, in: .weekOfYear, for: date)! - 1)))!
    }
    
    //MARK: - ScrollViewProxy
    func scrollToID(_ ID: String?, in proxy: ScrollViewProxy) {
        if let ID = ID {
            withAnimation {
                proxy.scrollTo(ID, anchor: .center)
            }
        }
        scrollTargetID = nil
    }
    
    func updateScrollTarget() {
        if let nearestSection = nearestSection {
            if nearestSection == todaySection {
                self.scrollTargetID = nearestSection.nearestLesson()?.id(sectionID: nearestSection.id)
            } else {
                self.scrollTargetID = nearestSection.id
            }
        }
    }
    
    //MARK: - Sections
    func updateSections() async {
        
        let sections: [LessonsSection]
        switch representationMode {
        case .dateBased:
            sections = element.dateBasedLessonsSections
            await MainActor.run {
                showWeeks = false
            }
        case .weekBased:
            sections = element.weekBasedLessonsSections
            await MainActor.run {
                showWeeks = true
            }
        }
        
        await MainActor.run {
            self.sections = sections
            
            switch representationMode {
            case .dateBased:
                self.nearestSection = element.nearestDateBasedSection
                self.todaySection = element.todayDateBasedSection
            case .weekBased:
                self.nearestSection = element.nearestWeekBasedSection
                self.todaySection = element.todayWeekBasedSection
                
            }
            
            if let nearestSection = self.nearestSection {
                if nearestSection == todaySection {
                    self.scrollTargetID = nearestSection.nearestLesson()?.id(sectionID: nearestSection.id)
                } else {
                    self.scrollTargetID = nearestSection.id
                }
            }
            

        }
    }
    
    //MARK: - SearchField
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
    
    //MARK: - DatePicker
    func scrollToDate(_ date: Date) {
        let scrollTargetSection: LessonsSection?
        switch representationMode {
        case .dateBased:
            let date = date.removedTime()
            scrollTargetSection = filteredSections(searchString: searchText, subgroup: subgroup).first { $0.date! >= date }
        case .weekBased:
            let week = date.educationWeek
            let weekday = date.weekDay()
            scrollTargetSection = filteredSections(searchString: searchText, subgroup: subgroup).first { section in
                let thisWeekOrLater = section.week >= week
                let thisDayOfTheWeekAndLaterThisWeek = section.week == week && section.weekday.rawValue >= weekday.rawValue
                
                return thisWeekOrLater && thisDayOfTheWeekAndLaterThisWeek
            }
        }
        
        scrollTargetID = scrollTargetSection?.id
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
    
    //MARK: - Toolbar
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
        case is Auditorium:
            return showEmployees == true && showGroups == true
        default:
            return false
        }
    }
    
}
