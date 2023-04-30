//
//  AuditoriumNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 30.04.23.
//

import SwiftUI

struct AuditoriumNavigationLink: View {
    @ObservedObject var auditorium: Auditorium
    
    var body: some View {
        NavigationLink {
            AuditoriumDetailedView(auditorium: auditorium)
        } label: {
            AuditoriumView(auditorium: auditorium)
        }
        .contextMenu {
            FavoriteButton(item: auditorium)
        }
    }
}
