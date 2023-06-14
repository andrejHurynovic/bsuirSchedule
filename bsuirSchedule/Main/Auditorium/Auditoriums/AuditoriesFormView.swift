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
            ForEach(auditories.sorted()) { auditorium in
                AuditoriumNavigationLink(auditorium: auditorium, style: .form)
            }
        } label: {
            Label("Аудитории", systemImage: Constants.Symbols.auditorium)
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
