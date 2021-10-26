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
            //remove all college and dormitories classrooms
            classrooms.filter { $0.building == 0 }.forEach { classroom in
                PersistenceController.shared.container.viewContext.delete(classroom)
            }
            ClassroomStorage.shared.save()
        }))
        self.save()
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
        var components = name.components(separatedBy: "-")
        
        let buildingString = components.removeLast()
        let nameString = components.joined(separator: "-")
        
        let result = Self.nameAndBuildingProbably(name: nameString, buildingString: buildingString)
        
        return values.value.first {
            $0.building == result.building &&
            $0.floor == result.floor &&
            $0.name == result.name
        }
    }
    
    static func nameAndBuildingProbably(name: String, buildingString: String) -> (floor: Int16, name: String, building: Int16) {
        //"Транзистор", "epam-104", "Столовая"
        if name.first!.isNumber == false {
            return (0, name, 99)
        }
        
        if let number = Int(name.trimmingCharacters(in: .letters)) {
            if number < 100 {
                if name.first == "0" {
                    //"04", "04а"
                    var groundFloorName = name
                    groundFloorName.removeFirst()
                    return (0, groundFloorName, building(string: buildingString))
                } else {
                    //"34", "34a", "4"
                    return(0, name, building(string: buildingString))
                }
            }
        }
        
        //"104", "522", "114а"
        if let floor = Int16(String(name.first!)) {
            var justName = name
            justName.removeFirst()
            return (floor, justName, building(string: buildingString))
        }
        return (0, "error", 0)
    }
    
    static func building(string: String) -> Int16 {
        guard let range = string.range(of: "к.") else {
            return 0
        }
        var string = string
        string.removeSubrange(range)
        if let buildingNumber = Int16(String(string.first!)) {
            return Int16(buildingNumber)
        } else {
            return 0
        }
    }
}
