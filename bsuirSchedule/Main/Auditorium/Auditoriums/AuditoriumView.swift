//
//  AuditoriumView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.10.21.
//

import SwiftUI

struct AuditoriumView: View {
    @ObservedObject var auditorium: Auditorium
    
    var body: some View {
        SquareTextView(title: auditorium.formattedName,
                   firstSubtitle: auditorium.type?.abbreviation,
                   secondSubtitle: auditorium.department?.abbreviation)
    }
    
}

struct AuditoriumView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(Auditorium.getAll() as [Auditorium], id: \.formattedName) { auditorium in
            AuditoriumView(auditorium: auditorium)
                .frame(width: 104, height: 104, alignment: .center)
                .baseBackground()
        }
    }
}
