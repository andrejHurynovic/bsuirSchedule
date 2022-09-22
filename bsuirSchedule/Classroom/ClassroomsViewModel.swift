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
    
    func classrooms(_ searchText: String, _ classroomsTypes: [ClassroomType: Binding<Bool>], _ buildings: [Bool]) -> [Classroom] {
//        if classroomsTypes.filter( {$0 == false} ).isEmpty,
//            buildings.filter( {$0 == false} ).isEmpty,
//            searchText == "" {
//            return classrooms
//        } else {
            return classrooms.filter { ($0.formattedName(showBuilding: true).localizedStandardContains(searchText)
                                        || ($0.departmentAbbreviation?.localizedStandardContains(searchText) ?? false)
                                        || searchText == "")
                && classroomsTypes[$0.type]!.wrappedValue == true
                && ($0.building == 99 || buildings[Int($0.building) - 1] == true)
            }
//        }
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
                sections.append(ClassroomSection(title: title(building: building, floor: floor),
                                                 classrooms: ClassroomStorage.shared.classrooms(building: building, floor: floor)))
            }
        }
        return sections
    }
    
    func title(building: Int16, floor: Int16) -> String {
        if building == 99 {
            return "Другие"
        }
        
        var title = "\(building)-ый корпус, "
        
        if floor == 0 {
            title.append("0-ой этаж")
        } else {
            title.append("\(floor)-ый этаж")
        }
        return title
    }
    
    static func classroomsTypesDefaults() -> [ClassroomType: Binding<Bool>] {
        [.lecture: .constant(true),
         .practice: .constant(true),
         .laboratory: .constant(true),
         .computerClass: .constant(false),
         .maintenance: .constant(false),
         .office: .constant(false),
         .scienceLaboratory: .constant(false)
        ]
    }
    
    static func buildingsDefaults() -> [Bool] {
        return [true, true, true, true, true, true, true, true, true]
    }

    func fetchClassrooms() {
        ClassroomStorage.shared.fetch()
    }
}
