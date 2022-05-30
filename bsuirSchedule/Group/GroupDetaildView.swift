//
//  GroupDetaildView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import SwiftUI

struct GroupDetaildView: View {
    
    @ObservedObject var group: Group
    
    var body: some View {
        List {
//            ScrollViewReader { proxy in
//                Form {
                    Section(group.speciality.name) {
                        CoolField("Cокращение", group.speciality.abbreviation)
                        CoolField("Факультет", group.speciality.faculty.abbreviation)
                        CoolField("Код", group.speciality.code)
                        CoolField("Форма обучения", group.speciality.getEducationTypeDescription())
                    }
            Section("Статистика") {
                Text(DateFormatters.shared.dateFormatterddMMyyyy.string(from: group.lastUpdateDate!))
                let _ = group.lessons?.allObjects as [Lesson]
            }
//                }
//            }
        }
        .navigationTitle(group.id)
        .refreshable {
            GroupStorage.shared.fetchDetailed(group)
        }
    }
}

struct CoolField: View  {
    var name: String
    var parameter: String

    init(_ name: String, _ parameter: String) {
        self.name = name
        self.parameter = parameter
    }
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text(parameter)
                .foregroundColor(.gray)
        }
    }
}

struct GroupDetaildView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetaildView(group: GroupStorage.shared.groups(ids: ["950503"]).first!)
    }
}
