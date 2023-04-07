//
//  GroupsSectionsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.10.22.
//

import SwiftUI

struct GroupsSectionsView: View {
    
    var sections: [GroupSection]
    var groupsCount: Int
    
    var body: some View {
        
        var sections = sections
        let lastSection: GroupSection? = sections.isEmpty == true ? nil as GroupSection? : sections.removeLast() as GroupSection?
        
        ForEach(sections, id: \.self) { section in
            Section(section.title) {
                ForEach(section.groups, id: \.id, content: { group in
                    GroupView(group: group)
                })
            }
        }
        
        if let section = lastSection {
            Section {
                ForEach(section.groups, id: \.id, content: { group in
                    GroupView(group: group)
                })
            } header: {
                Text(section.title)
                
            } footer: {
                Text("Всего групп: \(groupsCount)")
                
            }
        }
    }
    
}

