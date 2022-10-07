//
//  ClassroomsViewModel.swift
//  ClassroomsViewModel
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI
import Combine

class ClassroomsViewModel: ObservableObject {
    
    func update() async {
        for classroom in Classroom.getClassrooms() {
            PersistenceController.shared.container.viewContext.delete(classroom)
        }
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
        await Classroom.fetchAll()
        await MainActor.run {
            try! PersistenceController.shared.container.viewContext.save()
        }
    }
    
//    static func classroomsTypesDefaults() -> [ClassroomType: Binding<Bool>] {
//        [.lecture: .constant(true),
//         .practice: .constant(true),
//         .laboratory: .constant(true),
//         .computerClass: .constant(false),
//         .maintenance: .constant(false),
//         .office: .constant(false),
//         .scienceLaboratory: .constant(false)
//        ]
//    }
//
//    static func buildingsDefaults() -> [Bool] {
//        return [true, true, true, true, true, true, true, true, true]
//    }
//
//    func fetchClassrooms() {
//        ClassroomStorage.shared.fetch()
//    }
}
