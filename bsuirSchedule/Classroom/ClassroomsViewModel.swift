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
    
    func addClassroom(array: inout [Classroom]?, element: Classroom) {
        if array == nil {
            array = []
            array?.append(element)
        } else {
            array?.append(element)
        }
    }
    
    func classrooms(building: Int, _ searchText: String) -> [Character : [Classroom]] {
        var dictionary: [Character: [Classroom]] = [:]
        self.classrooms.filter {
            searchText.isEmpty ||
            $0.name!.localizedStandardContains(searchText) ||
            $0.departmentAbbreviation!.localizedStandardContains(searchText)
        }.forEach { classroom in
            addClassroom(array: &dictionary[classroom.name!.first!], element: classroom)
        }
        
        return dictionary
    }

    func fetchClassrooms() {
        ClassroomStorage.shared.fetch()
    }
}
