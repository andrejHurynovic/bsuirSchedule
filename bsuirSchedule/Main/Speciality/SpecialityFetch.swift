//
//  SpecialityFetch.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import CoreData

extension Speciality: AbleToFetchAll {
    static func fetchAll() async {
        guard let data = try? await URLSession.shared.data(for: .specialities) else { return }
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let (backgroundContext, decoder) = newBackgroundContextWithDecoder()
        
        guard let specialities = try? decoder.decode([Speciality].self, from: data) else {
            Log.error("Can't decode specialities.")
            return
        }
        
        await backgroundContext.perform(schedule: .immediate, {
            try! backgroundContext.save()
        })
        Log.info("\(String(specialities.count)) Specialities fetched, time: \((CFAbsoluteTimeGetCurrent() - startTime).roundTo(places: 3)) seconds.\n")
    }
}
