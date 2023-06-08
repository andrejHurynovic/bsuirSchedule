//
//  LessonsRefreshableView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 9.04.23.
//

import SwiftUI

struct LessonsRefreshableView<ObjectType: LessonsRefreshable>: View {
    
    @ObservedObject var item: ObjectType
    
    @State var lastUpdateDate: Date?
    
    var body: some View {
        HStack {
            Text("Последнее обновление")
            Spacer()
            if let date = lastUpdateDate {
                Text(date.formatted(date: .numeric, time: .omitted))
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
                    .task {
                        await fetchLastUpdateDate()
                    }
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
    }
    
    func fetchLastUpdateDate() async {
        guard let fetchedLastUpdateDate = await item.fetchLastUpdateDate() else { return }
        
        await MainActor.run {
            withAnimation {
                self.lastUpdateDate = fetchedLastUpdateDate
            }
        }
//        if let itemLastUpdateDate = item.lessonsUpdateDate,
//           itemLastUpdateDate < fetchedLastUpdateDate {
//            Task {
//                let _ = await item.update()
//            }
//        }
    }
}


struct LessonsUpdateDateView_Previews: PreviewProvider {
    static var previews: some View {
        let employees: [Employee] = Employee.getAll()
        if let employee = employees.randomElement() {
            LessonsRefreshableView(item: employee)
        }
    }
}
