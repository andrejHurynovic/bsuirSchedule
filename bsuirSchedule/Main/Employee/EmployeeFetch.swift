//
//  EmployeeFetch.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import CoreData

extension Employee: AbleToFetchAll {
    static func fetchAll() async {
        let data = try! await URLSession.shared.data(from: FetchDataType.employees.rawValue)
        let startTime = CFAbsoluteTimeGetCurrent()
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            Log.error("Can't create employees dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true
        
        var employees: [Employee] = getAll(from: backgroundContext)
        
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if var employee = employees.first (where: { $0.id == dictionary["id"] as? Int32 }) {
                try! decoder.update(&employee, from: data)
            } else {
                let employee = try! decoder.decode(Employee.self, from: data)
                employees.append(employee)
            }
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String(employees.count)) Employees fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
        
    }

}

//MARK: - Update

extension Employee {
    func update() async -> Employee? {
        guard let urlID = self.urlID,
              let url = URL(string: FetchDataType.employee.rawValue + urlID),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            Log.error("No data for employee (\(self.urlID ?? "no urlID"))")
            return nil
        }
        
        guard data.count != 0 else {
            Log.warning("Empty data while updating employee \(self.urlID ?? "no urlID") (\(String(self.id)))")
            return nil
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true
        
        var backgroundEmployee = backgroundContext.object(with: self.objectID) as! Employee
        let previousPhotoLink = backgroundEmployee.photoLink
        
        try! decoder.update(&backgroundEmployee, from: data)
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        
        if backgroundEmployee.photoLink != previousPhotoLink || backgroundEmployee.photoLink != nil, backgroundEmployee.photo == nil {
            backgroundEmployee.photo = await fetchPhoto()
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        
        return self
    }
    
    static func updateEmployees(employees: [Employee] = Employee.getAll()) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        try! await withThrowingTaskGroup(of: Employee?.self) { taskGroup in
            for employee in employees {
                taskGroup.addTask {
                    await employee.update()
                }
            }
            try await taskGroup.waitForAll()
        }
        Log.info("Employees updated in time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")
    }
    
}

//MARK: - Photo

extension Employee {
    func fetchPhoto() async -> Data? {
        guard let photoLink = self.photoLink,
              let url = URL(string: photoLink),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            Log.error("No data for employee photo (\(String(self.id)))")
            return nil
        }
        
        guard data.count != 0 else {
            Log.warning("Empty data while updating employee photo \(self.urlID ?? "no urlID") (\(String(self.id)))")
            return nil
        }
        
        Log.info("Employee \(self.urlID ?? "no urlID") (\(String(self.id))) photo has been updated.")
        return data
    }
    
}
