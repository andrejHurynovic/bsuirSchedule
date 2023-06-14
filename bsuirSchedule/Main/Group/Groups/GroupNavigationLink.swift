//
//  GroupNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

enum NavigationLinkStyle {
    case grid
    case form
}

import SwiftUI

struct GroupNavigationLink: View {
    @ObservedObject var group: Group
    var style: NavigationLinkStyle = .grid
    
    var body: some View {
        NavigationLink {
            ScheduleView(scheduled: group)
        } label: {
            switch style {
                case .grid:
                    GroupView(group: group)
                case .form:
                    Text(group.name)
            }
            
        }
        .contextMenu {
            FavoriteButton(item: group)
            CompoundScheduleButton(item: group)
        }
    }
}

struct GroupNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        
        if let group = groups.first(where: { $0.name == "950502" }) {
            GroupNavigationLink(group: group)
                .frame(width: 104, height: 104, alignment: .center)
                .baseBackground()
        }
    }
}
