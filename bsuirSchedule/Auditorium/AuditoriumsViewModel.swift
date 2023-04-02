//
//  AuditoriumsViewModel.swift
//  AuditoriumsViewModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

class AuditoriumsViewModel: ObservableObject {
    
    func calculatePredicate(_ selectedAuditoriumType: AuditoriumType?, _ searchText: String) -> NSPredicate {
        var predicates: [NSPredicate] = []
        
        if let type = selectedAuditoriumType {
            predicates.append(NSPredicate(format: "type.id == %@", String(type.id)))
        }
        if !searchText.isEmpty {
            predicates.append(
                NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "formattedName BEGINSWITH[c] %@", searchText),
                                                                   NSPredicate(format: "department.abbreviation BEGINSWITH[c] %@", searchText),
                                                                   NSPredicate(format: "department.name CONTAINS[c] %@", searchText)])
            )
        }
        //Combine all predicates with an AND operator to create the final predicate for filtering.
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
    }
    
    func update() async {
        await Auditorium.fetchAll()
    }
    
}
