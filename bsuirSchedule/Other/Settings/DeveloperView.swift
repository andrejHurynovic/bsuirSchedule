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
    @FetchRequest(entity: EducationType.entity(), sortDescriptors: []) var educationTypes: FetchedResults<EducationType>
    @FetchRequest(entity: Speciality.entity(), sortDescriptors: []) var specialities: FetchedResults<Speciality>
    @FetchRequest(entity: Department.entity(), sortDescriptors: []) var departments: FetchedResults<Department>
    @FetchRequest(entity: Auditorium.entity(), sortDescriptors: []) var auditories: FetchedResults<Auditorium>
    @FetchRequest(entity: AuditoriumType.entity(), sortDescriptors: []) var auditoriumTypes: FetchedResults<AuditoriumType>
    @FetchRequest(entity: Group.entity(), sortDescriptors: []) var groups: FetchedResults<Group>
    @FetchRequest(entity: Employee.entity(), sortDescriptors: []) var employees: FetchedResults<Employee>
    @FetchRequest(entity: Lesson.entity(), sortDescriptors: []) var lessons: FetchedResults<Lesson>
    @FetchRequest(entity: LessonType.entity(), sortDescriptors: []) var lessonTypes: FetchedResults<LessonType>
    @FetchRequest(entity: EducationTask.entity(), sortDescriptors: []) var tasks: FetchedResults<EducationTask>
    
    var body: some View {
        Form {
            Section("Удаление") {
                DeveloperDeleteView(name: "факультеты", symbol: "graduationcap.circle", elements: faculties)
                DeveloperDeleteView(name: "формы образования", symbol: "graduationcap.circle", elements: educationTypes)
                DeveloperDeleteView(name: "специальности", symbol: "book.circle", elements: specialities)
                DeveloperDeleteView(name: "подразделения", symbol: "person.2.circle", elements: departments)
                DeveloperDeleteView(name: "аудитории", symbol: Constants.Symbols.auditorium, elements: auditories)
                DeveloperDeleteView(name: "типы аудиторий", symbol: "building.columns.circle", elements: auditoriumTypes)
                DeveloperDeleteView(name: "группы", symbol: "person.2.circle", elements: groups)
                DeveloperDeleteView(name: "преподаватели", symbol: Constants.Symbols.employees, elements: employees)
                DeveloperDeleteView(name: "занятия", symbol: "books.vertical.circle", elements: lessons)
                DeveloperDeleteView(name: "типы занятий", symbol: "books.vertical.circle", elements: lessonTypes)
//                DeveloperDeleteView(name: "задания", symbol: "house.circle", elements: tasks)
            }
            
            Section("Загрузка") {
                DeveloperUpdateView<Faculty>(name: "факультеты", symbol: "graduationcap.circle")
                DeveloperUpdateView<Speciality>(name: "специальности", symbol: "book.circle")
                DeveloperUpdateView<Department>(name: "подразделения", symbol: "person.2.circle")
                DeveloperUpdateView<Auditorium>(name: "аудитории", symbol: Constants.Symbols.auditorium)
                DeveloperUpdateView<Group>(name: "группы", symbol: "person.2.circle")
                DeveloperUpdateView<Employee>(name: "преподаватели", symbol: "person.crop.circle")
                Button {
                    Task {
                        await LessonType.initDefaultLessonTypes()
                    }
                } label: {
                    Label("Инициализировать стандартные типы занятий", systemImage: "person.crop.circle")
                }
            }
            
            Section("Дополнительно") {
                
                Button {
                    let favoriteGroups = ["950502", "950503", "921701", "921703", "051006"]
                    let favoriteEmployees = ["l-podenok","v-login","d-marchenkov","d-kupriianova","d-pertsev","d-odinets"]
                    let favoriteAuditoriums = ["207-5","512-5", "321-4"]
                    let favoriteDepartments = ["ЭВМ","ПОИТ","ЭВС"]
                    let chadGroups = groups.filter { favoriteGroups.contains($0.name) }
                    let chadEmployees = employees.filter { favoriteEmployees.contains($0.urlID ?? "") }
                    let chadAuditoriums = auditories.filter { favoriteAuditoriums.contains($0.formattedName) }
                    let chadDepartments = departments.filter { favoriteDepartments.contains($0.abbreviation) }
                    for chadGroup in chadGroups {
                        chadGroup.favorite = true
                    }
                    for chadEmployee in chadEmployees {
                        chadEmployee.favorite = true
                    }
                    for chadAuditorium in chadAuditoriums {
                        chadAuditorium.favorite = true
                    }
                    for chadDepartment in chadDepartments {
                        chadDepartment.favorite = true
                    }
                    let task = EducationTask(subject: "ДП", context: PersistenceController.shared.container.viewContext)
                    task.note = "ГЭК"
                    task.deadline = Date(timeIntervalSince1970: 1686808800)
                    
                    
                    let cs1 = CompoundSchedule(context: PersistenceController.shared.container.viewContext)
                    cs1.addToGroups(NSSet(array: chadGroups))
                    cs1.name = "Друзья"
                    let cs2 = CompoundSchedule(context: PersistenceController.shared.container.viewContext)
                    cs2.name = "ГЭК"
                    cs2.addToEmployees(NSSet(array: chadEmployees))
                    
                    try! PersistenceController.shared.container.viewContext.save()
                } label: {
                    Text("VERY IMPORTANT")
                }
                
                Button {
                    let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
                    let compoundSchedule = CompoundSchedule(context: backgroundContext)
                    compoundSchedule.name = "TestBaka"
                    if let auditorium = auditories.first(where: { $0.formattedName == "207-5" }),
                       let backgroundAuditorium = backgroundContext.object(with: auditorium.objectID) as? Auditorium {
                        compoundSchedule.addToAuditories(backgroundAuditorium)
                    }
                    if let group = groups.first(where: { $0.name == "950502" }),
                       let backgroundGroup = backgroundContext.object(with: group.objectID) as? Group {
                        compoundSchedule.addToGroups(backgroundGroup)
                    }
                    if let employee = employees.first(where: { $0.lastName == "Перцев" }),
                       let backgroundEmployees = backgroundContext.object(with: employee.objectID) as? Employee {
                        compoundSchedule.addToEmployees(backgroundEmployees)
                    }
                    try! backgroundContext.save()
                } label: {
                    Label("Test compound schedule", systemImage: "person.crop.circle")
                }
                Button {
                    Log.info("Number of students: \(groups.map( {$0.numberOfStudents} ).reduce(0, +))")
                } label: {
                    Label("Количество студентов", systemImage: "person.crop.circle")
                }
                Button {
                    let employeesWithLessons = employees.filter { employee in
                        if let lessons = employee.lessons?.allObjects as? [Lesson], lessons.isEmpty == false {
                            return true
                        } else {
                            return false
                        }
                    }
                    
                    let sortedEmployees = employeesWithLessons.sorted {
                        ($0.lessons?.allObjects as! [Lesson]).count > ($1.lessons?.allObjects as! [Lesson]).count
                    }
                    if let employee = sortedEmployees.first {
                        Log.info("Employee with the biggest number of lessons: \(employee.lastName), lessons: \((employee.lessons?.allObjects as! [Lesson]).count)")
                    }
                } label: {
                    Label("Больше всего занятий у преподавателя", systemImage: "person.crop.circle")
                }
                
                Button {
                    var sortedEmployees = employees.sorted {
                        $0.groups?.count ?? 0 > $1.groups?.count ?? 0
                    }
                    
                    for _ in 0..<5 {
                        let employee = sortedEmployees.removeFirst()
                        Log.info("Employee with the biggest number of groups: \(employee.lastName), lessons: \((employee.groups)!.count), students: \(employee.groups!.map({ $0.numberOfStudents }).reduce(0, +))")
                        
                    }
                    
                } label: {
                    Label("Больше всего групп у преподавателя", systemImage: "person.crop.circle")
                }
                
                Button {
                    var sortedAuditories = auditories.sorted {
                        $0.lessons?.allObjects.count ?? 0 > $1.lessons?.allObjects.count ?? 0
                    }
                    
                    for _ in 0..<5 {
                        let auditorium = sortedAuditories.removeFirst()
                        Log.info("Auditorium with the biggest number of lessons: \(auditorium.formattedName), lessons: \(auditorium.lessons!.allObjects.count)")
                        
                    }
                    
                } label: {
                    Label("Больше всего занятий у кабинета", systemImage: "person.crop.circle")
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

struct DeveloperUpdateView<T: AbleToFetchAll>: View {
    
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
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
