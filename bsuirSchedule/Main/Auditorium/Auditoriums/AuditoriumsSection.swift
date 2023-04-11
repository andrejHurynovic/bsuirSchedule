//
//  AuditoriumsSection.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

extension Array where Element == Auditorium {
    ///Returns array of auditoriums sections grouped by building and floor
    func sections(_ type: AuditoriumSectionType) -> [NSManagedObjectsSection<Auditorium>] {
        switch type {
            case .building:
                return buildingBasedSections(floorSectioned: false)
            case .buildingAndFloor:
                return buildingBasedSections(floorSectioned: true)
            case .department:
                return departmentBasedSections()
        }
    }
    
    
    ///This function creates building sections for the array of Auditoriums.
    ///If floorSectioned is true, the sections will be grouped by building and floor.
    ///If floorSectioned is false, the sections will be grouped by building only.
    private func buildingBasedSections(floorSectioned: Bool) -> [NSManagedObjectsSection<Auditorium>] {
        var sections: [NSManagedObjectsSection<Auditorium>] = []
        let outsideUniversitySections = self.sectioned(by: \.outsideUniversity)
        
        if let insideUniversityAuditoriums = outsideUniversitySections[false] {
            let buildingAuditoriumsDictionaries = insideUniversityAuditoriums.sectioned(by: \.building)
                .sorted(by: { $0.key < $1.key })
            if floorSectioned {
                sections.append(contentsOf: buildingAuditoriumsDictionaries.map { buildingDictionary in
                    buildingDictionary.value.sectioned(by: \.floor)
                        .sorted { $0.key < $1.key }
                        .map { NSManagedObjectsSection(title: "\(buildingDictionary.key)-ый корпус, \($0.key == 0 ? "0-ой этаж" : "\($0.key)-ый этаж")",
                                                       items: $0.value) }
                }
                    .flatMap { $0 }
                )
            } else {
                sections.append(contentsOf: buildingAuditoriumsDictionaries.map( { NSManagedObjectsSection(title: "\($0.key)-ый корпус",
                                                                                                           items: $0.value) }))
            }
        }
        if let outsideUniversityAuditoriums = outsideUniversitySections[true] {
            sections.append(NSManagedObjectsSection(title: "Без подразделения",
                                                    items: outsideUniversityAuditoriums))
        }
        return sections
    }
    
    private func departmentBasedSections() -> [NSManagedObjectsSection<Auditorium>] {
        return self.sectioned(by: \.department)
            .sorted(by: {
                if $1.key == nil && $0.key != nil { return true }
                if $0.key == nil && $1.key != nil { return false }
                return $0.key!.abbreviation < $1.key!.abbreviation
            })
            .map { NSManagedObjectsSection(title: $0.key?.abbreviation ?? "Без подразделения",
                                           items: $0.value) }
    }
    
}
