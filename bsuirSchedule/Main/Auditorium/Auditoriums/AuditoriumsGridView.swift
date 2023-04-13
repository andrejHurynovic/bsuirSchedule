//
//  AuditoriumsGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import SwiftUI

struct AuditoriumsGridView: View {
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

struct AuditoriumsGridView_Previews: PreviewProvider {
    static var previews: some View {
        let auditoriums = Auditorium.getAll()
        
        ForEach(AuditoriumSectionType.allCases, id: \.self) { sectionType in
            ScrollView {
                AuditoriumsGridView(sections: auditoriums.sections(sectionType))
            }
            .baseBackground()
        }
    }
}
