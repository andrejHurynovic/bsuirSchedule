//
//  GroupsSectionsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

import SwiftUI

struct GroupsSectionsView: View {
    
    var sections: [GroupSection]
    
    var body: some View {
        ForEach(sections, id: \.self) { section in
            Section(section.title) {
                ForEach(section.groups, id: \.id, content: { group in
                    NavigationLink(destination: GroupDetailedView(viewModel: GroupViewModel(group))){
                        Text(group.id)
                    }
                    .contextMenu {
                        FavoriteButton(group.favourite) {
                            group.favourite.toggle()
                        }
                    }
                })
            }
        }
    }
    
}

