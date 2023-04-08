//
//  LessonsUpdateDateView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 9.04.23.
//

import SwiftUI

struct LessonsUpdateDateView<ObjectType: LessonsUpdateDateable>: View {
    
    @ObservedObject var item: ObjectType
    
    var body: some View {
        HStack {
            Text("Последнее обновление")
            Spacer()
            if let date = item.lessonsUpdateDate {
                Text(date.formatted(date: .numeric, time: .omitted))
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
                    .task {
                        if item.lessonsUpdateDate == nil {
                            await fetchLastUpdateDate()
                        }
                    }
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
    }
    
    func fetchLastUpdateDate() async {
        guard let fetchedLastUpdateDate = await item.fetchLastUpdateDate() else { return }
        
        await MainActor.run {
            withAnimation {
                item.lessonsUpdateDate = fetchedLastUpdateDate
            }
        }
        if let itemLastUpdateDate = item.lessonsUpdateDate,
           itemLastUpdateDate < fetchedLastUpdateDate {
            let _ = await item.update()
        }
    }
}


struct LessonsUpdateDateView_Previews: PreviewProvider {
    static var previews: some View {
        let employees = Employee.getAll()
        if let employee = employees.randomElement() {
            LessonsUpdateDateView(item: employee)
        }
    }
}
