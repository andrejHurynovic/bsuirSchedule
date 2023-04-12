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
        SquareGrid(sections: sections, content: { group in
            NavigationLink {
                GroupDetailedView(group: group)
            } label: {
                GroupView(group: group)
            }
            .contextMenu {
                FavoriteButton(item: group)
            }
        })
        .padding([.horizontal, .bottom])
    }
}

struct GroupsGridView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = Group.getAll()
        
        ForEach(GroupSectionType.allCases, id: \.self) { sectionType in
            ScrollView {
                GroupsGridView(sections: groups.sections(sectionType))
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
