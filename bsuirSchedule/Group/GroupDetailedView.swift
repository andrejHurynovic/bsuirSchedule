//
//  GroupDetaildView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 21.04.22.
//

import SwiftUI
import Combine

struct GroupDetailedView: View {
    
    @ObservedObject var viewModel: GroupViewModel
    
    var body: some View {
        List {
            information
            Section {
                educationDates
                lastUpdate
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .refreshable {
            viewModel.update()
        }
    }
    
    @ViewBuilder var information: some View {
        Section(viewModel.group.speciality.name) {
            Form("Аббревиатура", viewModel.group.speciality.abbreviation)
            Form("Факультет", viewModel.group.speciality.faculty.abbreviation)
            Form("Шифр", viewModel.group.speciality.code)
            Form("Форма обучения", viewModel.group.speciality.educationType.description)
        }
    }
    
    @ViewBuilder var educationDates: some View {
        if viewModel.group.educationStart != nil || viewModel.group.examsStart != nil {
            if let educationStart = viewModel.group.educationStart, let educationEnd = viewModel.group.educationEnd {
                Button {
                    withAnimation {
                        viewModel.showEducationDuration.toggle()
                    }
                } label: {
                    Form("Семестр", viewModel.showEducationDuration ? "\((educationStart...educationEnd).numberOfDaysBetween()) дней" : "\(DateFormatters.shared.get(.longDate).string(from: educationStart)) – \(DateFormatters.shared.get(.longDate).string(from: educationEnd))")
                }
            }
            if let examsStart = viewModel.group.examsStart, let examsEnd = viewModel.group.examsEnd {
                Button {
                    withAnimation {
                        viewModel.showExamsDuration.toggle()
                    }
                } label: {
                    Form("Сессия", viewModel.showExamsDuration ? "\((examsStart...examsEnd).numberOfDaysBetween()) дней" : "\(DateFormatters.shared.get(.longDate).string(from: examsStart)) – \(DateFormatters.shared.get(.longDate).string(from: examsEnd))")
                }
            }
        }
    }
    
    @ViewBuilder var lastUpdate: some View {
        HStack {
            Text("Последнее обновление")
            Spacer()
            if let date = viewModel.lastUpdateDate {
                Text("\(DateFormatters.shared.longDate.string(from: date))")
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
    }
    
}

struct GroupDetaildView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailedView(viewModel: GroupViewModel(GroupStorage.shared.groups(ids: ["950503"]).first!))
    }
}
