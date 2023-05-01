//
//  AuditoriumFetch.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import CoreData

extension Auditorium: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .auditories) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        guard let dictionaries = try! JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            Log.error("Can't create auditories dictionaries.")
            return
        }
        
        let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        let decoder = JSONDecoder()
        decoder.userInfo[.managedObjectContext] = backgroundContext
        
        let auditories: [Auditorium] = getAll(from: backgroundContext)
        //This is required because decoder actually can throw an error here, so we can't decode whole array instantly.
        for dictionary in dictionaries {
            let data = try! JSONSerialization.data(withJSONObject: dictionary)
            
            let name = dictionary["name"] as! String
            let buildingDictionary = dictionary["buildingNumber"] as! [String: Any]
            let buildingString = buildingDictionary["name"] as! String
            
            
            if var auditorium = auditories.first (where: {
                if $0.outsideUniversity {
                    return "\($0.name)-\($0.building)" == "\(name)-\(buildingString.first!)"
                } else {
                    return  $0.formattedName == "\(name)-\(buildingString.first!)"
                }
            }) {
                try? decoder.update(&auditorium, from: data)
            } else {
                let _ = try? decoder.decode(Auditorium.self, from: data)
            }
        }
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
            Log.info("\(String((self.getAll(from: backgroundContext) as [Auditorium]).count)) Auditories fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
        })
    }
    
}
