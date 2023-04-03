//
//  AuditoriumsGridView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 4.04.23.
//

import SwiftUI

struct AuditoriumsGridView: View {
    let sections: [AuditoriumSection]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .leading, spacing: 8, pinnedViews: []) {
            ForEach(sections, id: \.title) { section in
                Section {
                    ForEach(section.auditoriums) { auditorium in
                        NavigationLink {
                            AuditoriumDetailedView(auditorium: auditorium)
                        } label: {
                            AuditoriumView(auditorium: auditorium)
                        }
                    }
                } header: {
                    standardizedHeader(title: section.title)
                }
                
            }
        }
        .padding()
    }
}

struct AuditoriumsGridView_Previews: PreviewProvider {
    static var previews: some View {
        var auditoriums = Auditorium.getAll()
        
        ForEach(AuditoriumSectionType.allCases, id: \.self) { sectionType in
            ScrollView {
                AuditoriumsGridView(sections: auditoriums.sections(sectionType))
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}
