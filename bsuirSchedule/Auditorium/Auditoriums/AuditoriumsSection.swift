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
        var auditoriums = self
        let outsideUniversitySection = auditoriums.removeOutsideUniversity()
        
        //Group the Auditoriums by building and sort the resulting dictionary by building number.
        let buildingSectionedDictionaries = Dictionary(grouping: auditoriums) { $0.building }
            .sorted { $0.key < $1.key }
        
        if floorSectioned {
            let buildingAndFloorSections = buildingSectionedDictionaries
                .map { buildingSectionedDictionary in
                    //Group the Auditoriums in each building, sectioned by floor and sort the resulting dictionary by floor number.
                    let dictionaries = Dictionary(grouping: buildingSectionedDictionary.value) { $0.floor }
                        .sorted(by: { $0.key < $1.key })
                    let sections = dictionaries.map {
                        NSManagedObjectsSection(title: "\(buildingSectionedDictionary.key)-ый корпус, \($0.key == 0 ? "0-ой этаж" : "\($0.key)-ый этаж")",
                                                items: $0.value) }
                    return sections
                }
            sections.append(contentsOf: buildingAndFloorSections.joined())
        } else {
            let buildingSections = buildingSectionedDictionaries.map {
                NSManagedObjectsSection(title: "\($0.key)-ый корпус",
                                        items: $0.value)
            }
            sections.append(contentsOf: buildingSections)
        }
        
        //This section should be at the end of the list.
        if let section = outsideUniversitySection {
            sections.append(section)
        }
        
        return sections
    }
    
    private func departmentBasedSections() -> [NSManagedObjectsSection<Auditorium>] {
        //Group the auditoriums by department and sort the resulting dictionary by department abbreviation
        return Dictionary(grouping: self) { $0.department }
            .sorted(by: { $0.key?.abbreviation ?? "Я" < $1.key?.abbreviation ?? "Я" })
            .map { NSManagedObjectsSection(title: $0.key?.abbreviation ?? "Без подразделения",
                                           items: $0.value) }
    }
    
    ///Removes all Auditories located outside the university, returns AuditoriumSection with such auditories.
    private mutating func removeOutsideUniversity() -> NSManagedObjectsSection<Auditorium>? {
        let auditoriumsOutsideUniversity = self.filter { $0.outsideUniversity }
        ///If there are no such Audiences, empty section is unnecessary, so nil is returned.
        guard auditoriumsOutsideUniversity.isEmpty == false else {
            return nil
        }
        
        self.removeAll{ $0.outsideUniversity }
        return NSManagedObjectsSection(title: "Вне университета",
                                       items: auditoriumsOutsideUniversity)
    }
    
}
