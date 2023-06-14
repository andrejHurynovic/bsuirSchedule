//
//  EmployeesViewModel.swift
//  EmployeesViewModel
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI
import Combine

class EmployeesViewModel: ObservableObject {
    @Published var predicate: NSPredicate?
    
    @Published var searchText = ""
    @Published var selectedSectionType: EmployeeSectionType = .firstLetter
    @Published var showDepartments = false
    
    @Published var scrollTargetID: String = ""
    
    var showSectionIndexes: Bool {
        selectedSectionType == .firstLetter
    }
    
    @Published var cancellables = Set<AnyCancellable>()
    
    var menuDefaultRules: [Bool] { [selectedSectionType == .firstLetter] }
    
    //MARK: - Initialization
    
    init() {
        addSearchTextPublisher()
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
    
    //MARK: - Methods
    
    static func update() async {
        await Employee.fetchAll()
        await Employee.updateEmployees()
    }
    
    ///This method calculates a predicate to filter the list of Employees based on a search query. It takes a search query as an argument and returns an NSPredicate object. The predicate is constructed based on the search query and it filters Employees by their last name, first name, department name or department abbreviation. If the search query is empty, the method returns nil, which means that no filtering is needed.
    private func calculatePredicate() {
        guard !searchText.isEmpty else {
            self.predicate = nil
            return
        }
        self.predicate =  NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "lastName BEGINSWITH[c] %@", searchText),
                                                                             NSPredicate(format: "firstName BEGINSWITH[c] %@", searchText),
                                                                             NSPredicate(format: "ANY departments.name CONTAINS[c] %@", searchText),
                                                                             NSPredicate(format: "ANY departments.abbreviation BEGINSWITH[c] %@", searchText)])
        
    }
    
}
