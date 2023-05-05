//
//  AuditoriesViewModel.swift
//  AuditoriesViewModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI
import Combine

class AuditoriesViewModel: ObservableObject {
    @Published var predicate: NSPredicate?
    
    @Published var searchText = ""
    @Published var selectedSectionType: AuditoriumSectionType = .building
    @Published var selectedAuditoriumType: AuditoriumType? = nil
    
    @Published var cancellables = Set<AnyCancellable>()
    
    var menuDefaultRules: [Bool] { [selectedSectionType == .building,
                                    selectedAuditoriumType == nil] }
    
    //MARK: - Initialization

    init() {
        addSearchTextPublisher()
        addSelectedAuditoriumTypePublisher()
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
    private func addSelectedAuditoriumTypePublisher() {
        $selectedAuditoriumType
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.calculatePredicate()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Methods
    
    static func update() async {
        await Auditorium.fetchAll()
    }
    
    ///This method calculates a predicate to filter the list of Auditories based on a selected auditorium type and a search query. The method constructs a compound predicate based on the list of predicates using the AND operator.
    private func calculatePredicate () {
        var predicates: [NSPredicate] = []
        
        if let type = selectedAuditoriumType {
            predicates.append(NSPredicate(format: "type.id == %@", String(type.id)))
        }
        if searchText.isEmpty == false {
            predicates.append(
                NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "formattedName BEGINSWITH[c] %@", searchText),
                                                                   NSPredicate(format: "department.name CONTAINS[c] %@", searchText),
                                                                   NSPredicate(format: "department.abbreviation BEGINSWITH[c] %@", searchText)])
            )
        }
        //Combine all predicates with an AND operator to create the final predicate for filtering.
        self.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}
