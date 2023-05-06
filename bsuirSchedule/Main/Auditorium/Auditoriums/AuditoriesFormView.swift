//
//  AuditoriesFormView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 5.05.23.
//

import SwiftUI

struct AuditoriesFormView: View {
    var auditories: [Auditorium]
    
    var body: some View {
        DisclosureGroup {
            ForEach(auditories.sorted(by: { $0.formattedName < $1.formattedName })) { auditorium in
                AuditoriumFormNavigationLink(auditorium: auditorium)
            }
        } label: {
            Label("Аудитории", systemImage: Constants.Symbols.auditorium)
        }
    }
}

struct AuditoriumFormNavigationLink: View {
    @ObservedObject var auditorium: Auditorium
    
    var body: some View {
        NavigationLink(auditorium.formattedName) {
            AuditoriumDetailedView(auditorium: auditorium)
        }
    }
    
}

struct AuditoriesFormView_Previews: PreviewProvider {
    static var previews: some View {
        let auditories: [Auditorium] = Auditorium.getAll()
        NavigationView {
            Form {
                AuditoriesFormView(auditories: auditories)
            }
        }
    }
}
