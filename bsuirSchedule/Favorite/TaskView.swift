//
//  TaskView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 3.11.21.
//

import SwiftUI

struct TaskView: View {
    var task: Hometask
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(mainMaterial())
            .aspectRatio(contentMode: .fill)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(task.subject!)
                            .font(Font.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(Color.primary)
                        Spacer()
                        Text(task.lessonType!)
                            .foregroundColor(Color.primary)
                        Text(relativelyNow())
                            .font(.headline)
                            .fontWeight(.regular)
                            .foregroundColor(Date() < task.deadline! ? Color.gray : Color.red)
                    }
                    Spacer()
                }
                .padding()
            }
        
    }

    func relativelyNow() -> String {
        let today = Date()
        
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateTimeFormatter.dateTimeStyle = .numeric
        relativeDateTimeFormatter.unitsStyle = .short
        relativeDateTimeFormatter.locale = Locale(identifier: "RU-ru")
        
        var string = relativeDateTimeFormatter.localizedString(for: task.deadline!, relativeTo: today)
        
        if today < task.deadline! {
            string = string.components(separatedBy: " ").dropFirst().joined(separator: " ")
        } else {
            string = string.components(separatedBy: " ").dropLast().joined(separator: " ")
        }
    
        return string
    }
}
