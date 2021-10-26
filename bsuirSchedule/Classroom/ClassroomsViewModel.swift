//
//  ClassroomsViewModel.swift
//  ClassroomsViewModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI
import Combine

struct ClassroomSection: Hashable {
    var title: String
    var classrooms: [Classroom]
    
    func classrooms(_ searchText: String, _ classroomsTypes: [Bool]) -> [Classroom] {
        if classroomsTypes.filter( {$0 == false} ).isEmpty, searchText == "" {
            return classrooms
        } else {
            return classrooms.filter { ($0.formattedName(showBuilding: true).localizedStandardContains(searchText)
                                        || ($0.departmentAbbreviation?.localizedStandardContains(searchText) ?? false)
                                        || searchText == "")
                                        && classroomsTypes[Int($0.typeValue) - 1] == true }
        }
    }
}



class ClassroomsViewModel: ObservableObject {
    @Published var classrooms: [Classroom] = []
    
    private var cancelable: AnyCancellable?
    
    init(classroomPublisher: AnyPublisher<[Classroom], Never> = ClassroomStorage.shared.values.eraseToAnyPublisher()) {
        cancelable = classroomPublisher.sink { classrooms in
            self.classrooms = classrooms
        }
    }
    
    func sections() -> [ClassroomSection] {
        var sections: [ClassroomSection] = []
        ClassroomStorage.shared.buildings().forEach { building in
            ClassroomStorage.shared.floors(building).forEach { floor in
                sections.append(ClassroomSection(title: "\(building) корпус \(floor) этаж",
                                                 classrooms: ClassroomStorage.shared.classrooms(building: building, floor: floor)))
            }
        }
        return sections
    }
    
    static func classroomsTypesDefaults() -> [Bool] {
        return [true, true, true, false, false, false, false]
    }

    func fetchClassrooms() {
        ClassroomStorage.shared.fetch()
    }
}
