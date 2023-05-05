//
//  GroupFetch.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import CoreData

//MARK: - Fetch

extension Group: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .groups) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            Log.error("Can't create group dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true

        var groups: [Group] = getAll(from: backgroundContext)
        
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            if var group = groups.first (where: { $0.name == dictionary["name"] as? String }) {
                try! decoder.update(&group, from: data)
            } else {
                let group = try! decoder.decode(Group.self, from: data)
                groups.append(group)
            }
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String(groups.count)) Groups fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
    }
    
}

//MARK: - Update
extension Group {
    func update() async -> Group? {
        guard let url = URL(string: FetchDataType.group.rawValue + self.name),
              let (data, _) = try? await URLSession.shared.data(from: url) else {
            Log.error("No data for group (\(String(self.name)))")
            return nil
        }
        
        guard data.count != 0 else {
            Log.warning("Empty data while updating group (\(String(self.name)))")
            return nil
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        decoder.userInfo[.groupEmbeddedContainer] = true
        
        var backgroundGroup = backgroundContext.object(with: self.objectID) as! Group
        try! decoder.update(&backgroundGroup, from: data)
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        
        return self
    }
    
    static func updateGroups(groups: [Group] = Group.getAll()) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        try! await withThrowingTaskGroup(of: Group?.self) { taskGroup in
            for studentGroup in groups {
                taskGroup.addTask {
                    await studentGroup.update()
                }
            }
            try await taskGroup.waitForAll()
        }
        Log.info("Groups updated in time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds")

    }
    
}
