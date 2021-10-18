//
//  SpecialityStorage.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 15.10.21.
//

import Foundation

class SpecialityStorage: Storage<Speciality> {
    
    static let shared = SpecialityStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Speciality.name, ascending: true),
                                                            NSSortDescriptor(keyPath: \Speciality.educationTypeValue, ascending: true)])
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .specialities, completion: {(specialities: [Speciality]) -> () in }))
        self.save()
    }
}
