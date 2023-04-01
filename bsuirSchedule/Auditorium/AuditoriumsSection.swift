//
//  AuditoriumsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

struct AuditoriumSection: Hashable {
    var title: String
    var auditoriums: [Auditorium]
}

extension Array where Element == Auditorium {
    ///Returns array of auditoriums filtered by building and auditoriumType if they are presented
    func filtered(by building: Int16?, _ auditoriumType: AuditoriumType?) -> [Auditorium] {
        var auditoriums = self
        if let building = building {
            auditoriums.removeAll { $0.building != building }
        }
        if let auditoriumType = auditoriumType {
            auditoriums.removeAll { $0.type != auditoriumType }
        }
        return auditoriums
    }
    
    ///Returns array of auditoriums sections grouped by building and floor
    func sections() -> [AuditoriumSection] {
        var sections: [AuditoriumSection] = []
        let buildings = Set(self.map { $0.building }).sorted()
        
        let auditoriumsOutsideUniversity = self.filter({ $0.outsideUniversity == true }).sorted(by: { $0.name < $1.name })
        if auditoriumsOutsideUniversity.isEmpty == false  {
            sections.append(AuditoriumSection(title: "Другие",
                                             auditoriums: auditoriumsOutsideUniversity))
        }
        
        for building in buildings {
            let buildingAuditoriums = self.filter { $0.building == building && $0.outsideUniversity == false }
            let floors = Set(buildingAuditoriums.map { $0.floor }).sorted()
            for floor in floors {
                sections.append(AuditoriumSection(title: "\(building)-ый корпус, \(floor == 0 ? "0-ой этаж" : "\(floor)-ый этаж")",
                                                 auditoriums: buildingAuditoriums.filter( {$0.floor == floor })))
            }
        }
        return sections
    }
    
}
