//
//  FacultyStorage.swift
//  FacultyStorage
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import Foundation

class FacultyStorage: Storage<Faculty> {
    
    static let shared = FacultyStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Faculty.abbreviation, ascending: true)])
    
    var faculties: [Faculty] {
        self.values.value
    }
    //Факультеты, у которых есть хотя бы одна специальность
    var activeFaculties: [Faculty] {
        self.values.value.filter { faculty in
            (faculty.specialities?.allObjects as! [Speciality]).filter { speciality in
                speciality.groups?.allObjects.isEmpty == false
            }.isEmpty == false
        }
    }
    
    func faculty(id: Int16) -> Faculty? {
        return faculties.first(where: {$0.id == id})
    }
    
    //MARK: Fetch
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .faculties, completion: {(faculties: [Faculty]) -> () in self.save()}))
    }
    
}
