//
//  AuditoriesSectionGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import SwiftUI

struct AuditoriesSectionGridView: View {
    var sections: [NSManagedObjectsSection<Auditorium>]
    
    var body: some View {
        SquareGrid(sections: sections, content: { auditorium in
            AuditoriumNavigationLink(auditorium: auditorium)
        })
        .padding([.horizontal, .bottom])
    }
}

struct AuditoriesGridView_Previews: PreviewProvider {
    static var previews: some View {
        let auditories: [Auditorium] = Auditorium.getAll()
        
        ForEach(AuditoriumSectionType.allCases, id: \.self) { sectionType in
            ScrollView {
                AuditoriesSectionGridView(sections: auditories.sections(sectionType))
            }
            .baseBackground()
        }
    }
}
