//
//  AuditoriumNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import SwiftUI

struct AuditoriumNavigationLink: View {
    @ObservedObject var auditorium: Auditorium
    var style: NavigationLinkStyle = .grid
    
    var body: some View {
        NavigationLink {
            AuditoriumDetailedView(auditorium: auditorium)
        } label: {
            switch style {
                case .grid:
                    AuditoriumView(auditorium: auditorium)
                case .form:
                    Text(auditorium.formattedName)
            }
        }
        .contextMenu {
            FavoriteButton(item: auditorium)
            CompoundScheduleButton(item: auditorium)
        }
    }
}
