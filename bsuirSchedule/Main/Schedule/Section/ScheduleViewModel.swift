//
//  ScheduleViewModel.swift
//  ScheduleViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import Combine

class ScheduleViewModel: ObservableObject {
    
    @Published var selectedSectionType: ScheduleSectionType = .date
    
    @Published var showScrollView = false
    
    @Published var targetSection: ScheduleSection?
    var scrollWithAnimation = true
    
    @Published var searchText = ""
    @Published var showSearchField = false
    
    @Published var selectedDate = Date()
    @Published var showDatePicker = false
    
    @Published var selectedSubgroup: Int?
    
    var sections: [ScheduleSection]?
    @Published var filteredSections: [ScheduleSection]?
    
    var cancellables = Set<AnyCancellable>()
    
    var defaultRules: Bool {
        return ![searchText.isEmpty,
                 selectedSubgroup == nil,
                 selectedSectionType == .date].contains(false)
    }
    
    init() {
        addSelectedDateSubscriber()
        addSearchTextSubscriber()
    }
    
    //MARK: - Subscribers
    
    func addSelectedDateSubscriber() {
        $selectedDate
            .sink { [weak self] date in
                guard let self = self else { return }
                self.showDatePicker = false
                Task {
                    await self.scrollToDate(date)
                }
            }
            .store(in: &cancellables)
    }
    func addSearchTextSubscriber() {
        $searchText
            .debounce(for: .seconds(0.5),
                      scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.updateFilteredSections()
            }
            .store(in: &cancellables)
        
    }
    
    //MARK: - Sections
    
    func updateSections(_ lessons: [Lesson]?) async {
        guard let lessons = lessons else { return }
        
//        if let dividedEducationDates = lessons.dividedEducationDates {
//            if let nextDates = dividedEducationDates.nextDates {
//                let nextSections = await lessons
//                    .sections(selectedSectionType, educationDates: nextDates)
//                await MainActor.run {
//                    self.sections = nextSections
//                    self.filteredSections = nextSections.filtered(abbreviation: self.searchText, subgroup: self.selectedSubgroup)
//                }
//            }
//
//            if let previousDates = dividedEducationDates.previousDates {
//                let previousSections = await lessons
//                    .sections(selectedSectionType, educationDates: previousDates)
//                await MainActor.run {
//                    scrollWithAnimation = false
//                    targetSection = self.sections?.first
//                    if self.sections != nil {
//                        self.sections?.insert(contentsOf: previousSections, at: .zero)
//                        self.filteredSections?.insert(contentsOf: previousSections
//                            .filtered(abbreviation: self.searchText, subgroup: self.selectedSubgroup), at: .zero)
//                    } else {
//                        self.sections = previousSections
//                        self.filteredSections = previousSections.filtered(abbreviation: self.searchText, subgroup: self.selectedSubgroup)
//                    }
//
//                                withAnimation(.linear(duration: 0.1)) {
//                                    showScrollView = true
//                                }
//                }
//            }
//        }
        
        let sections = await lessons.sections(selectedSectionType)
        let closestSection = await sections.closest(to: .now, type: selectedSectionType)

        await MainActor.run {
            self.sections = sections
            self.filteredSections = sections.filtered(abbreviation: self.searchText, subgroup: self.selectedSubgroup)

            scrollWithAnimation = true
            targetSection = closestSection

            withAnimation(.linear(duration: 0.1)) {
                showScrollView = true
            }
        }
        
    }
    
    
    func updateFilteredSections() {
        guard let sections = self.sections else { return }
        guard self.searchText.isEmpty == false || selectedSubgroup != nil else {
            self.filteredSections = sections
            Task {
                await self.scrollToDate(.now,
                                        withAnimation: false)
            }
            return
        }
        
        self.filteredSections = self.sections.map( { $0.filtered(abbreviation: searchText, subgroup: selectedSubgroup) })
        Task {
            await self.scrollToDate(.now,
                                    withAnimation: false)
        }
    }
    
    //MARK: - ScrollViewProxy
    func scrollTo(section: ScheduleSection?,
                  in proxy: ScrollViewProxy) {
        if let targetSection = section {
            if scrollWithAnimation {
                withAnimation {
                    proxy.scrollTo(targetSection.id, anchor: .top)
                }
            } else {
                proxy.scrollTo(targetSection.id, anchor: .top)
            }
        }
        self.targetSection = nil
    }
    
    func scrollToDate(_ date: Date, withAnimation: Bool = true) async {
        self.scrollWithAnimation = withAnimation
        let section = await filteredSections?.closest(to: date,
                                                      type: selectedSectionType)
        await MainActor.run {
            targetSection = section
        }
        
    }
    
}
