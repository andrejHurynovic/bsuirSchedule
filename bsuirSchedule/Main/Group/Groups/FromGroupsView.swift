//
//  FromGroupsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

import SwiftUI

struct FromGroupsView: View {
    var groups: [Group]
    
    @ViewBuilder var body: some View {
        var sections = groups.sections(.specialityName)
        
        if let lastSection = sections.last {
            let _ = sections.removeLast()
            ForEach(sections, id: \.id) { section in
                Section(section.title) {
                    ForEach(section.items, id: \.id, content: { group in
                        FromGroupView(group: group)
                    })
                }
            }
            
            Section {
                ForEach(lastSection.items, id: \.name, content: { group in
                    FromGroupView(group: group)
                })
            } header: {
                Text(lastSection.title)
            } footer: {
                Text("Всего групп: \(groups.count)")
                
            }
        }
    }
    
}

struct FormGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        
        NavigationView {
            Form {
                FromGroupsView(groups: groups)
            }
        }
    }
}
