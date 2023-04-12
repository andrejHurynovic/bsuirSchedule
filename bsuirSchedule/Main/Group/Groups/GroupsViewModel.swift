//
//  GroupsViewModel.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import SwiftUI

class GroupsViewModel: ObservableObject {
    @Published var searchText = ""
    
    @Published var selectedSectionType: GroupSectionType = .specialityAbbreviation
    @Published var selectedFaculty: Faculty? = nil
    @Published var selectedSpecialtyEducationType: EducationType? = nil
    @Published var selectedEducationDegree: EducationDegree? = nil
    @Published var selectedCourse: Int16? = nil
    
    var menuDefaultRules: [Bool] { [selectedSectionType == .specialityAbbreviation,
                                    selectedFaculty == nil,
                                    selectedSpecialtyEducationType == nil,
                                    selectedEducationDegree == nil,
                                    selectedCourse == nil] }
    
    static func update() async {
        await Group.fetchAll()
        await Group.updateGroups()
    }
    
    func calculatePredicate() -> NSPredicate? {
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
            predicates.append(NSCompoundPredicate(orPredicateWithSubpredicates: [NSPredicate(format: "id BEGINSWITH %@", searchText),
                                                                                 NSPredicate(format: "speciality.abbreviation BEGINSWITH[c] %@", searchText),
                                                                                 NSPredicate(format: "speciality.name BEGINSWITH[c] %@", searchText)]))
        }
        
        guard predicates.isEmpty == false else { return nil }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
    }
    
}


