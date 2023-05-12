//
//  GroupView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import SwiftUI

struct GroupView: View {
    @ObservedObject var group: Group
    
    var body: some View {
        SquareTextView(title: group.name,
                   firstSubtitle: group.nickname ?? group.speciality?.faculty?.abbreviation,
                   secondSubtitle: group.speciality?.abbreviation)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        
        if let group = groups.first(where: { $0.name == "950502" }) {
            GroupView(group: group)
                .frame(width: 104, height: 104, alignment: .center)
                .baseBackground()
        }
    }
}
