//
//  GroupStorage.swift
//  GroupStorage
//
//  Created by Andrej Hurynovič on 10.09.21.
//

import Foundation

class GroupStorage: Storage<Group> {
    
    static let shared = GroupStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Group.id, ascending: true)])
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .groups, completion: {(groups: [Group]) -> () in
            self.save()
            self.fetchAllDetailed()
        }))
    }
    
    func fetchAllDetailed() {
        self.values.value.forEach { group in
            if group.lessons?.count == 0 {
                fetchDetailed(group)
            }
        }
    }
    
    func fetchDetailed(_ group: Group) {
        cancellables.insert(FetchManager.shared.fetch(dataType: .group, argument: group.id, completion: {(fetchedGroup: Group) -> () in
            if let lessons = fetchedGroup.lessons {
                group.addToLessons(lessons)
            }
            group.educationStart = fetchedGroup.educationStart
            group.educationEnd = fetchedGroup.educationEnd
            group.examsStart = fetchedGroup.examsStart
            group.examsEnd = fetchedGroup.examsEnd
            self.save()
            
        }))
    }
    
    func favorites() -> [Group] {
        return self.values.value.filter{ $0.favorite }
    }
    
    
    
    //MARK: Group Section
    
    static func sections(_ groups: [Group],
                  _ searchText: String,
                  _ selectedFaculty: Faculty?,
                  _ selectedEducationType: Int?,
                  _ sortedBy: GroupSortingType = .speciality) -> [GroupSection] {
        
        var filitredGroups = groups.filter { group in
            searchText.isEmpty ||
            group.id!.localizedStandardContains(searchText) ||
            group.speciality!.abbreviation!.localizedStandardContains(searchText)
        }
        
        if let selectedFaculty = selectedFaculty {
            filitredGroups = filitredGroups.filter {$0.speciality?.faculty == selectedFaculty}
        }
        
        if let selectedEducationType = selectedEducationType {
            filitredGroups = filitredGroups.filter {$0.speciality!.educationTypeValue == selectedEducationType}
        }
        
        return sort(groups: filitredGroups, sortedBy)
    }
    
    static private func sort(groups: [Group], _ sortedBy: GroupSortingType) -> [GroupSection] {
        var sections: [GroupSection] = []
        
        switch sortedBy {
        case .number:
            var groupPrefixes = Set<String.SubSequence>()
            groups.map{$0.id!.prefix(3)}.forEach { subSequence in
                groupPrefixes.insert(subSequence)
            }
            
            groupPrefixes.sorted().forEach { prefixSequence in
                sections.append(GroupSection(title: String(prefixSequence),
                                             groups: groups.filter{$0.id!.prefix(3) == prefixSequence}))
            }
        case .speciality:
            SpecialityStorage.shared.values.value.forEach { speciality in
                let specialityGroups = groups.filter{$0.speciality == speciality}
                if specialityGroups.isEmpty == false {
                    sections.append(GroupSection(
                        title: "\(speciality.name!) (\(speciality.getEducationTypeDescription()), \(speciality.faculty!.abbreviation!))" ,
                        groups: specialityGroups))
                }
            }
        }
        
        return sections
    }
}

struct GroupSection: Hashable {
    var title: String
    var groups: [Group]
}

enum GroupSortingType: Equatable, CaseIterable {
    case number
    case speciality
}
