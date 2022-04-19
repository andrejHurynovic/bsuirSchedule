//
//  FacultyStorage.swift
//  FacultyStorage
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import Foundation

class FacultyStorage: Storage<Faculty> {
    
    static let shared = FacultyStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Faculty.abbreviation, ascending: true)])
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .faculties, completion: {(faculties: [Faculty]) -> () in self.save()}))
    }
    
    func faculties() -> [Faculty] {
        self.values.value.filter { faculty in
            (faculty.specialities?.allObjects as! [Speciality]).filter { speciality in
                speciality.groups?.allObjects.isEmpty == false
            }.isEmpty == false
        }
    }
}
