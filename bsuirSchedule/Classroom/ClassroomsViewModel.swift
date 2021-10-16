//
//  ClassroomsViewModel.swift
//  ClassroomsViewModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI
import Combine

class ClassroomsViewModel: ObservableObject {
    @Published var classrooms: [Classroom] = []
    
    private var cancelable: AnyCancellable?
    
    init(classroomPublisher: AnyPublisher<[Classroom], Never> = ClassroomStorage.shared.classrooms.eraseToAnyPublisher()) {
        cancelable = classroomPublisher.sink { classrooms in
            self.classrooms = classrooms
        }
    }
    
    func classrooms(building: Int, _ searchText: String) -> [ClassroomSection] {
        var sections: [ClassroomSection] = []
        
        let foundClassrooms = classrooms.filter{$0.building == building}
        var floors = Set<String.SubSequence>()
        
        foundClassrooms.map {$0.name!.prefix(1)}.forEach { subSequence in
            floors.insert(subSequence)
        }
        
        floors
            .filter { Int($0) != nil }
            .sorted()
            .forEach { floor in
                var title = String(floor)
                if floor == "0" {
                    title = title + "-ой этаж"
                } else {
                    title = title + "-ый этаж"
                }
                sections.append(ClassroomSection(title: title,
                                                 classrooms: foundClassrooms.filter {$0.name!.prefix(1) == floor}))
            }
        
        var otherClassrooms: [Classroom] = []
        
        floors
            .filter { Int($0) == nil }
            .sorted()
            .forEach { subSequence in
                otherClassrooms.append(contentsOf: foundClassrooms.filter{$0.name!.prefix(1) == subSequence})
            }
        
        if otherClassrooms.isEmpty == false {
            sections.append(ClassroomSection(title: "Другие", classrooms: otherClassrooms))
        }
        
        return sections
        
    }

    func fetchClassrooms() {
        ClassroomStorage.shared.fetch()
    }
}



struct ClassroomSection: Hashable {
    var title: String
    var classrooms: [Classroom]
}
