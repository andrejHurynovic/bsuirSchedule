//
//  DepartmentsViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI
import Combine

class DepartmentsViewModel: ObservableObject {
    @Published var predicate: NSPredicate?
    
    @Published var searchText = ""
    
    @Published var cancellables = Set<AnyCancellable>()
    
    //MARK: - Initialization

    init() {
        addSearchTextPublisher()
    }
    
    private func addSearchTextPublisher() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.calculatePredicate()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    
    static func update() async {
        await Department.fetchAll()
    }
    
    private func calculatePredicate () {
        guard searchText.isEmpty == false else {
            self.predicate = nil
            return
        }
        self.predicate =  NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "abbreviation BEGINSWITH[c] %@", searchText),
                                                                             NSPredicate(format: "name CONTAINS[c] %@", searchText)])
    }
}


