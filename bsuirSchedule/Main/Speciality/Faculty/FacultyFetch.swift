//
//  FacultyFetch.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import CoreData

extension Faculty: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .faculties) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let (backgroundContext, decoder) = newBackgroundContextWithDecoder()
        
        guard let faculties = try? decoder.decode([Faculty].self, from: data) else {
            Log.error("Can't decode faculties.")
            return
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        Log.info("\(String(faculties.count)) Faculties fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
    }
    
}
