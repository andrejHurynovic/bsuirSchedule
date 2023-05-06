//
//  ScheduleViewModel.swift
//  ScheduleViewModel
//
//  Created by Andrej Hurynovič on 19.09.21.
//

import SwiftUI
import Combine

class ScheduleViewModel: ObservableObject {
    
    @Published var selectedRepresentationType: ScheduleRepresentationType = .page
    @Published var selectedSectionType: ScheduleSectionType = .date
    
    @Published var showScrollView = false
    
    @Published var selectedSectionID: String = ""
    private var scrollWithAnimation = true
    
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
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.updateFilteredSections()
            }
            .store(in: &cancellables)
        
    }
    
    //MARK: - Sections
    
    func updateSections(_ lessons: [Lesson]?) async {
        guard let lessons = lessons,
        lessons.isEmpty == false else { return }
        
        let sections = await lessons.sections(selectedSectionType)
        let filteredSections = sections.filtered(abbreviation: self.searchText, subgroup: self.selectedSubgroup)
        let closestSection = await sections.closest(to: .now, type: selectedSectionType)
        
        await MainActor.run {
            self.sections = sections
            self.filteredSections = filteredSections
        
            switch selectedRepresentationType {
                case .page:
                    self.selectedSectionID = closestSection?.id ?? ""
                    showScrollView = false
                case .scroll:
                    self.selectedSectionID = ""
                    Task {
                        await MainActor.run {
                            scrollWithAnimation = false
                            self.selectedSectionID = closestSection?.id ?? ""
                            withAnimation(.linear(duration: 0.1)) {
                                showScrollView = true
                            }
                        }
                    }
            }
            
        }
        
    }
    
    
    func updateFilteredSections() {
        guard let sections = self.sections else { return }
        guard self.searchText.isEmpty == false || selectedSubgroup != nil else {
            self.filteredSections = sections
            Task {
                await self.scrollToDate(.now,
                                        scrollWithAnimation: false)
            }
            return
        }
        
        self.filteredSections = self.sections.map( { $0.filtered(abbreviation: searchText, subgroup: selectedSubgroup) })
        Task {
            await self.scrollToDate(.now,
                                    scrollWithAnimation: false)
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
    func scrollTo(_ targetID: String?,
                  in proxy: ScrollViewProxy) {
        if let targetID = targetID {
            if scrollWithAnimation {
                withAnimation {
                    proxy.scrollTo(targetID, anchor: .top)
                }
            } else {
                proxy.scrollTo(targetID, anchor: .top)
            }
        }
        self.selectedSectionID = ""
    }
    
}
