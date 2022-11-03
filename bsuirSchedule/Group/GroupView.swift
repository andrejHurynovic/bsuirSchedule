//
//  GroupView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.11.22.
//

import SwiftUI

struct GroupView: View {
    @State var group: Group
    
    var body: some View {
        NavigationLink(destination: GroupDetailedView(viewModel: GroupViewModel(group))){
            Text(group.id)
        }
        .contextMenu {
            FavoriteButton(group.favourite) {
                group.favourite.toggle()
            }
        }
    }
}
