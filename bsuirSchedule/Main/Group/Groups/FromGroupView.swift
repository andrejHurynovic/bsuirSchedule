//
//  FromGroupView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.11.22.
//

import SwiftUI

struct FromGroupView: View {
    @ObservedObject var group: Group
    
    var body: some View {
        NavigationLink(destination: GroupDetailedView(group: group)){
            Text(group.name)
        }
        .contextMenu {
            FavoriteButton(item: group)
        }
    }
}
