//
//  GroupsGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import SwiftUI

struct GroupsGridView: View {
    var sections: [NSManagedObjectsSection<Group>]
    
    var body: some View {
        SectionsSquareGrid(sections: sections, content: { group in
            GroupNavigationLink(group: group)
        })
        .padding([.horizontal, .bottom])
    }
}

struct GroupsGridView_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        
        ForEach(GroupSectionType.allCases, id: \.self) { sectionType in
            ScrollView {
                GroupsGridView(sections: groups.sections(sectionType))
            }
            .baseBackground()
        }
    }
}
