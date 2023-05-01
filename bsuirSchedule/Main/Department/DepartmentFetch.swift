//
//  DepartmentFetch.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import CoreData

extension Department: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .departments) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let (backgroundContext, decoder) = newBackgroundContextWithDecoder()
        
        guard let departments = try? decoder.decode([Department].self, from: data) else {
            Log.error("Can't decode departments.")
            return
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        Log.info("\(String(departments.count)) Departments fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
    }
}
