//
//  ClassroomsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

struct ClassroomSection: Hashable {
    var title: String
    var classrooms: [Classroom]
}

extension Array where Element == Classroom {
    ///Returns array of classrooms filtered by building and classroomType if they are presented
    func filtered(by building: Int16?, _ classroomType: ClassroomType?) -> [Classroom] {
        var classrooms = self
        if let building = building {
            classrooms.removeAll { $0.building != building }
        }
        if let classroomType = classroomType {
            classrooms.removeAll { $0.type != classroomType }
        }
        return classrooms
    }
    
    ///Returns array of classrooms sections grouped by building and floor
    func sections() -> [ClassroomSection] {
        var sections: [ClassroomSection] = []
        let buildings = Set(self.map { $0.building }).sorted()
        
        let classroomsOutsideUniversity = self.filter({ $0.outsideUniversity == true }).sorted(by: { $0.name < $1.name })
        if classroomsOutsideUniversity.isEmpty == false  {
            sections.append(ClassroomSection(title: "Другие",
                                             classrooms: classroomsOutsideUniversity))
        }
        
        for building in buildings {
            let buildingClassrooms = self.filter { $0.building == building && $0.outsideUniversity == false }
            let floors = Set(buildingClassrooms.map { $0.floor }).sorted()
            for floor in floors {
                sections.append(ClassroomSection(title: "\(building)-ый корпус, \(floor == 0 ? "0-ой этаж" : "\(floor)-ый этаж")",
                                                 classrooms: buildingClassrooms.filter( {$0.floor == floor })))
            }
        }
        return sections
    }
    
}
