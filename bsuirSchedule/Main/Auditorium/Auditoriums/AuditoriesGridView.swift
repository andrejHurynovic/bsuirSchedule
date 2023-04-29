//
//  AuditoriesGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import SwiftUI

struct AuditoriesGridView: View {
    var sections: [NSManagedObjectsSection<Auditorium>]
    
    var body: some View {
        SquareGrid(sections: sections, content: { auditorium in
            NavigationLink {
                AuditoriumDetailedView(auditorium: auditorium)
            } label: {
                AuditoriumView(auditorium: auditorium)
            }
            .contextMenu {
                FavoriteButton(item: auditorium)
            }
        })
        .padding([.horizontal, .bottom])
    }
}

struct AuditoriesGridView_Previews: PreviewProvider {
    static var previews: some View {
        let auditories = Auditorium.getAll()
        
        ForEach(AuditoriumSectionType.allCases, id: \.self) { sectionType in
            ScrollView {
                AuditoriesGridView(sections: auditories.sections(sectionType))
            }
            .baseBackground()
        }
    }
}
