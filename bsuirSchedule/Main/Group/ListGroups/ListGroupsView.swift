//
//  ListGroupsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

import SwiftUI

struct ListGroupsView: View {
    var groups: [Group]
    
    @ViewBuilder var body: some View {
        var sections = groups.sections(.specialityName)
        
        if let lastSection = sections.last {
            let _ = sections.removeLast()
            ForEach(sections, id: \.title) { section in
                Section(section.title) {
                    ForEach(section.items, id: \.id, content: { group in
                        ListGroupView(group: group)
                    })
                }
            }
            
            Section {
                ForEach(lastSection.items, id: \.id, content: { group in
                    ListGroupView(group: group)
                })
            } header: {
                Text(lastSection.title)
            } footer: {
                Text("Всего групп: \(groups.count)")
                
            }
        }
    }
    
}

struct ListGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = Group.getAll()
        
        NavigationView {
            Form {
                ListGroupsView(groups: groups)
            }
        }
    }
}
