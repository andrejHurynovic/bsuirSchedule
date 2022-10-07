//
//  ClassroomStorage.swift
//  ClassroomStorage
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import Foundation

class ClassroomStorage: Storage<Classroom> {
    
    static let shared = ClassroomStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Classroom.building, ascending: true),
                                                           NSSortDescriptor(keyPath: \Classroom.floor, ascending: true),
                                                           NSSortDescriptor(keyPath: \Classroom.name, ascending: true)])
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .classrooms, completion: {(classrooms: [Classroom]) -> () in
            //Delete all classrooms with error
            classrooms.filter { classroom in
                classroom.originalName == "error"
            }.forEach { classroom in
                self.delete(classroom)
            }
            self.save()
        }))
    }
    
    
    
    func buildings() -> [Int16] {
        Set(self.values.value.map { $0.building }).sorted()
    }
    
    func floors(_ building: Int16) -> [Int16] {
        Set(self.values.value.filter { $0.building == building }.map { $0.floor }).sorted()
    }
    
    func classrooms(building: Int16, floor: Int16) -> [Classroom] {
        self.values.value.filter { $0.building == building && $0.floor == floor }
    }
    
    func classroom(name: String) -> Classroom?  {
        return values.value.first {$0.originalName == name}
    }

    
    
}
