//
//  GroupsViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import SwiftUI
import Combine

class GroupsViewModel: ObservableObject {
    @Published var predicate: NSPredicate?
    
    @Published var searchText = ""
    
    @Published var selectedSectionType: GroupSectionType = .specialityAbbreviation
    @Published var selectedFaculty: Faculty?
    @Published var selectedSpecialtyEducationType: EducationType?
    @Published var selectedEducationDegree: EducationDegree?
    @Published var selectedCourse: Int16?
    
    @Published var cancellables = Set<AnyCancellable>()
    
    var menuDefaultRules: [Bool] { [selectedSectionType == .specialityAbbreviation,
                                    selectedFaculty == nil,
                                    selectedSpecialtyEducationType == nil,
                                    selectedEducationDegree == nil,
                                    selectedCourse == nil] }
    
    //MARK: - Initialization
    
    init() {
        addSearchTextPublisher()
        addSelectionSubscribers()
    }
    
    private func addSearchTextPublisher() {
        $searchText
            .debounce(for: Constants.searchDebounceTime, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.calculatePredicate()
            }
            .store(in: &cancellables)
    }
    private func addSelectionSubscribers() {
        Publishers
            .CombineLatest4($selectedFaculty, $selectedSpecialtyEducationType, $selectedEducationDegree, $selectedCourse)
            .debounce(for: Constants.searchDebounceTime, scheduler:  DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.calculatePredicate()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    
    static func update() async {
        await Group.fetchAll()
//        await Group.updateGroups()
    }
    
    private func calculatePredicate() {
        var predicates: [NSPredicate] = []
        if let selectedFaculty = selectedFaculty {
            predicates.append(NSPredicate(format: "speciality.faculty == %@", selectedFaculty))
        }
        if let selectedSpecialtyEducationType = selectedSpecialtyEducationType {
            predicates.append(NSPredicate(format: "speciality.educationType == %@", selectedSpecialtyEducationType))
        }
        if let selectedEducationDegree = selectedEducationDegree {
            predicates.append(NSPredicate(format: "educationDegreeValue == \(selectedEducationDegree.rawValue)"))
        }
        if let selectedCourse = selectedCourse {
            predicates.append(NSPredicate(format: "course == \(selectedCourse)"))
        }
        if searchText.isEmpty == false {
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "name BEGINSWITH %@", searchText),
                                                                                 NSPredicate(format: "speciality.abbreviation BEGINSWITH[c] %@", searchText),
                                                                                 NSPredicate(format: "speciality.name BEGINSWITH[c] %@", searchText)]))
        }
        
        guard predicates.isEmpty == false else {
            self.predicate = nil
            return
        }
        
        self.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
    }
    
}


