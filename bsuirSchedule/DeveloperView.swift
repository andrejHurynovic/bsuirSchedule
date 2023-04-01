//
//  DeveloperView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

import SwiftUI
import CoreData

struct DeveloperView: View {
    
    @FetchRequest(entity: Faculty.entity(), sortDescriptors: []) var faculties: FetchedResults<Faculty>
    @FetchRequest(entity: Speciality.entity(), sortDescriptors: []) var specialities: FetchedResults<Speciality>
    @FetchRequest(entity: Department.entity(), sortDescriptors: []) var departments: FetchedResults<Department>
    @FetchRequest(entity: Auditorium.entity(), sortDescriptors: []) var auditoriums: FetchedResults<Auditorium>
    @FetchRequest(entity: AuditoriumType.entity(), sortDescriptors: []) var auditoriumTypes: FetchedResults<AuditoriumType>
    @FetchRequest(entity: Group.entity(), sortDescriptors: []) var groups: FetchedResults<Group>
    @FetchRequest(entity: Employee.entity(), sortDescriptors: []) var employees: FetchedResults<Employee>
    @FetchRequest(entity: Lesson.entity(), sortDescriptors: []) var lessons: FetchedResults<Lesson>
    @FetchRequest(entity: Hometask.entity(), sortDescriptors: []) var tasks: FetchedResults<Hometask>

    var body: some View {
        List {
            Section("Удаление") {
                DeveloperDeleteView(name: "факультеты", symbol: "graduationcap.circle", elements: faculties)
                DeveloperDeleteView(name: "специальности", symbol: "book.circle", elements: specialities)
                DeveloperDeleteView(name: "подразделения", symbol: "book.circle", elements: departments)
                DeveloperDeleteView(name: "аудитории", symbol: "building.columns.circle", elements: auditoriums)
                DeveloperDeleteView(name: "типы аудиторий", symbol: "building.columns.circle", elements: auditoriumTypes)
                DeveloperDeleteView(name: "группы", symbol: "person.2.circle", elements: groups)
                DeveloperDeleteView(name: "преподаватели", symbol: "person.crop.circle", elements: employees)
                DeveloperDeleteView(name: "занятия", symbol: "books.vertical.circle", elements: lessons)
                DeveloperDeleteView(name: "задания", symbol: "house.circle", elements: tasks)
            }
            
            Section("Загрузка") {
                DeveloperUpdateView<Faculty>(name: "факультеты", symbol: "graduationcap.circle")
                DeveloperUpdateView<Speciality>(name: "специальности", symbol: "book.circle")
                DeveloperUpdateView<Auditorium>(name: "аудитории", symbol: "building.columns.circle")
                DeveloperUpdateView<Group>(name: "группы", symbol: "person.2.circle")
                DeveloperUpdateView<Employee>(name: "преподаватели", symbol: "person.crop.circle")
            }
            
            Section("Дополнительно") {
                Button {
                    Log.info("Number of students: \(groups.map( {$0.numberOfStudents} ).reduce(0, +))")
                } label: {
                    Label("Количество студентов", systemImage: "person.crop.circle")
                }

            }
            
        }
        .navigationTitle("Разработчик")
    }
    
}

struct DeveloperDeleteView<T: NSFetchRequestResult>: View {
    
    var name: String
    var symbol: String
    var elements: FetchedResults<T>
    
    var body: some View {
        Button(role: .destructive) {
            for element in elements {
                PersistenceController.shared.container.viewContext.delete(element as! NSManagedObject)
            }
            try! PersistenceController.shared.container.viewContext.save()
        } label: {
            Label("Удалить \(name) (\(elements.count))", systemImage: symbol)
                .foregroundColor(.red)
        }
    }
    
}

struct DeveloperUpdateView<T: DecoderUpdatable>: View {
    
    var name: String
    var symbol: String
    
    var body: some View {
        Button {
            Task {
                await T.fetchAll()
                await MainActor.run {
                    try! PersistenceController.shared.container.viewContext.save()
                }
            }
           
        } label: {
            Label("Загрузить \(name)", systemImage: symbol)
        }
    }
    
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}
