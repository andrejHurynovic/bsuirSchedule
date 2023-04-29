//
//  AuditoriumsViewModel.swift
//  AuditoriumsViewModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

class AuditoriumsViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var selectedSectionType: AuditoriumSectionType = .building
    @Published var selectedAuditoriumType: AuditoriumType? = nil
    
    var menuDefaultRules: [Bool] { [selectedSectionType == .building,
                                    selectedAuditoriumType == nil] }
    func update() async {
        await Auditorium.fetchAll()
    }
    
    ///This method calculates a predicate to filter the list of Auditoriums based on a selected auditorium type and a search query. The method constructs a compound predicate based on the list of predicates using the AND operator.
    func calculatePredicate () -> NSPredicate {
        var predicates: [NSPredicate] = []
        
        if let type = selectedAuditoriumType {
            predicates.append(NSPredicate(format: "type.id == %@", String(type.id)))
        }
        if !searchText.isEmpty {
            predicates.append(
                NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "formattedName BEGINSWITH[c] %@", searchText),
                                                                   NSPredicate(format: "department.name CONTAINS[c] %@", searchText),
                                                                   NSPredicate(format: "department.abbreviation BEGINSWITH[c] %@", searchText)])
            )
        }
        //Combine all predicates with an AND operator to create the final predicate for filtering.
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
    }
}
