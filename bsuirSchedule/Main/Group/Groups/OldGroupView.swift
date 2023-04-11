//
//  OldGroupView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.11.22.
//

import SwiftUI

struct OldGroupView: View {
    @State var group: Group
    
    var body: some View {
        NavigationLink(destination: GroupDetailedView(group: group)){
            Text(group.id)
        }
        .contextMenu {
            FavoriteButton(item: group)
        }
    }
}
