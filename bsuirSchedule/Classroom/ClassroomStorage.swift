//
//  ClassroomStorage.swift
//  ClassroomStorage
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import Foundation

class ClassroomStorage: Storage<Classroom> {
    
    static let shared = ClassroomStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Classroom.building, ascending: true),
                                                           NSSortDescriptor(keyPath: \Classroom.name, ascending: true)])
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .classrooms, completion: {(classrooms: [ClassroomModel]) -> () in
            classrooms.filter({(1...7).contains($0.building)}) .forEach { classroom in
                    let newClassroom = Classroom(classroom)
                    if (6...7).contains(classroom.building) {
                        newClassroom.building += 1
                    }
                }
                ClassroomStorage.shared.save()
        }))
        self.save()
    }
    
    func classroom(name: String) -> Classroom? {
        var name = name
        let range = name.range(of: "к.")!
        name.removeSubrange(range)
        name = name.trimmingCharacters(in: .whitespaces)
        
        let separator = name.lastIndex(of: "-")!
        let classroom = values.value.first { $0.name! == name.prefix(upTo: separator) && $0.building == Int(String(name.last!))! }
        
        return classroom
    }
}
