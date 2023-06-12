//
//  ScheduleViewModel.swift
//  ScheduleViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import Combine

class ScheduleViewModel: ObservableObject {
    
    @Published var selectedRepresentationType: ScheduleRepresentationType = .scroll
    @Published var selectedSectionType: ScheduleSectionType = .date
    @Published var state: ScheduleViewState = .initialSectionUpdating
    
    @Published var showScrollView = false
    
    @Published var selectedSectionID: String = ""
    private var scrollWithAnimation = true
    
    @Published var searchText = ""
    @Published var showSearchField = false
    
    @Published var selectedDate = Date()
    @Published var showDatePicker = false
    
    @Published var selectedSubgroup: Int?
    
    @Published var selectedHometaskLesson: Lesson?
    
    var sections: [ScheduleSection]?
    @Published var filteredSections: [ScheduleSection]?
    
    var cancellables = Set<AnyCancellable>()
    
    var defaultRules: Bool {
        return ![selectedSubgroup == nil,
                 selectedSectionType == .date].contains(false)
    }
    
    init() {
        addSelectedRepresentationType()
        addSelectedSubgroupSubscriber()
        addSearchTextSubscriber()
        addSelectedDateSubscriber()
    }
    
    //MARK: - Subscribers

    private func addSelectedRepresentationType() {
        $selectedRepresentationType
            .debounce(for: Constants.placeholderDebounce, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.updateFilteredSections(returnToClosestSection: true)
                }
            }
            .store(in: &cancellables)
        
    }
    private func addSelectedSubgroupSubscriber() {
        $selectedSubgroup
            .debounce(for: Constants.placeholderDebounce, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.updateFilteredSections(returnToClosestSection: true)
                }
            }
            .store(in: &cancellables)

    }
    private func addSearchTextSubscriber() {
        $searchText
            .debounce(for: Constants.searchDebounceTime, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.updateFilteredSections(returnToClosestSection: true)
                }
            }
            .store(in: &cancellables)
        
    }
    private func addSelectedDateSubscriber() {
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
    
    //MARK: - Sections
    func updateSections(_ lessons: [Lesson]?, educationDates: [Date]? = nil) async {
        guard let lessons = lessons,
        lessons.isEmpty == false else { return }
        
        self.sections = await lessons.sections(selectedSectionType, educationDates: educationDates)
        await updateFilteredSections(returnToClosestSection: true)
    }
    
    
    func updateFilteredSections(returnToClosestSection: Bool = true) async {
        guard let sections = self.sections else { return }
        
        let filteredSections: [ScheduleSection]?
        if self.searchText.isEmpty == true && selectedSubgroup == nil {
            filteredSections = sections
        } else {
            filteredSections = self.sections.map( { $0.filtered(abbreviation: searchText, subgroup: selectedSubgroup) })
        }
        await MainActor.run {
            withAnimation {
                self.filteredSections = filteredSections
            }
        }
        if returnToClosestSection {
            await initialScroll()
        } else {
            await MainActor.run {
                withAnimation {
                    self.state = .showingSections
                }
            }
        }
    }
    
    func updateState() async {

    }
    
    private func initialScroll() async {
        let closestSectionID = (await self.filteredSections?.closest(to: .now, type: selectedSectionType))?.id ?? ""
        
        await MainActor.run {
            switch selectedRepresentationType {
                case .page:
                    self.selectedSectionID = closestSectionID
                    showScrollView = false
                case .scroll:
                    self.selectedSectionID = ""
                    Task {
                        await MainActor.run {
                            scrollWithAnimation = false
                            self.selectedSectionID = closestSectionID
                            showScrollView = true
                            self.state = .showingSections
                        }
                    }
            }
        }
    }
    
    func scrollToDate(_ date: Date, scrollWithAnimation: Bool = true) async {
        self.scrollWithAnimation = scrollWithAnimation
        let section = await filteredSections?.closest(to: date,
                                                      type: selectedSectionType)
        await MainActor.run {
            withAnimation {
                self.selectedSectionID = section?.id ?? ""
            }
        }
        
    }
    
    //MARK: - ScrollViewProxy
    func scrollTo(_ targetID: String,
                  in proxy: ScrollViewProxy) {
        if targetID.isEmpty == false {
            if scrollWithAnimation {
                withAnimation {
                    proxy.scrollTo(targetID, anchor: .top)
                }
            } else {
                proxy.scrollTo(targetID, anchor: .top)
            }
            self.selectedSectionID = ""
        }
    }
    
}
