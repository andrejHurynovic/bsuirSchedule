//
//  GroupStorage.swift
//  GroupStorage
//
//  Created by Andrej Hurynovič on 10.09.21.
//

import Foundation
import Combine

class GroupStorage: Storage<Group> {
    
    static let shared = GroupStorage(sortDescriptors: [NSSortDescriptor(keyPath: \Group.id, ascending: true)])
    
    func groups(ids: [String]) -> [Group] {
        self.values.value.filter {ids.contains($0.id)}
    }
    
    //MARK: Fetch
    
    func fetch() {
        cancellables.insert(FetchManager.shared.fetch(dataType: .groups, completion: {(groups: [Group]) -> () in
            self.save()
        }))
    }
    
    func fetchAllDetailed() {
        self.values.value.forEachInout { group in
            if group.updateDate == nil  {
                update(group)
            }
        }
    }
    
    func update(_ group: Group) {
        var cancellable: AnyCancellable? = nil
        cancellable = FetchManager.shared.fetch(dataType: .group, argument: group.id, completion: {[weak self] (fetchedGroup: Group) -> () in
            if let lessons = fetchedGroup.lessons {
                group.removeFromLessons(group.lessons!)
                group.addToLessons(lessons)
            }
            group.educationStart = fetchedGroup.educationStart
            group.educationEnd = fetchedGroup.educationEnd
            group.examsStart = fetchedGroup.examsStart
            group.examsEnd = fetchedGroup.examsEnd
            group.updateDate = Date()
            self?.save()
        })
        cancellables.insert(cancellable!)
    }
    
    //MARK: Accesors
    
    func favorites() -> [Group] {
        return self.values.value.filter { $0.favorite }
    }
    
    //MARK: Group Section
    
    static func sections(_ groups: [Group],
                  _ searchText: String,
                  _ selectedFaculty: Faculty?,
                  _ selectedEducationType: EducationType?,
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
            filitredGroups = filitredGroups.filter {$0.speciality!.educationType == selectedEducationType}
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
            SpecialityStorage.shared.values.value.forEachInout { speciality in
                let specialityGroups = groups.filter{$0.speciality == speciality}
                if specialityGroups.isEmpty == false {
                    sections.append(GroupSection(
                        title: "\(speciality.name!) (\(speciality.educationType.description), \(speciality.faculty!.abbreviation!))" ,
                        groups: specialityGroups))
                }
            }
        }
        
        return sections
    }
    
    func delete(id: String) {
        let group = values.value.first(where: {$0.id == id})
        if let group = group {
            #warning("//удаляет только если после будет ещё одно сохранение, нужно переделать")
            PersistenceController.shared.container.viewContext.delete(group)
        }
    }
}

//MARK: GroupSection

struct GroupSection: Hashable {
    var title: String
    var groups: [Group]
}

enum GroupSortingType: Equatable, CaseIterable {
    case number
    case speciality
}
