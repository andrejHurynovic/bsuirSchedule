//
//  GroupNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import SwiftUI

struct GroupNavigationLink: View {
    @ObservedObject var group: Group
    
    var body: some View {
        NavigationLink {
            ScheduleView(scheduled: group)
        } label: {
            GroupView(group: group)
        }
        .contextMenu {
            FavoriteButton(item: group)
        }
    }
}

struct GroupNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        let groups = Group.getAll()
        
        if let group = groups.first(where: { $0.name == "950502" }) {
            GroupNavigationLink(group: group)
                .frame(width: 104, height: 104, alignment: .center)
                .baseBackground()
        }
    }
}
