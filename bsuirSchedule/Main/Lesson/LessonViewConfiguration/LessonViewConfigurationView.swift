//
//  LessonViewConfigurationView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 8.06.23.
//

import SwiftUI

struct LessonViewConfigurationView: View {
    @ObservedObject var lessonViewConfiguration: LessonViewConfiguration
    
    var body: some View {
        Text("Отображать:")
//        Toggle("Аббревиатуру", isOn: $lessonViewConfiguration.showFullSubject.animation())
        Toggle("Группы", isOn: $lessonViewConfiguration.showGroups.animation())
        Toggle("Преподавателей", isOn: $lessonViewConfiguration.showEmployees.animation())
        Toggle("Недели", isOn: $lessonViewConfiguration.showWeeks.animation())
        Toggle("Период", isOn: $lessonViewConfiguration.showDates.animation())
        Toggle("Дату", isOn: $lessonViewConfiguration.showDate.animation())
    }
}

struct LessonViewConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(defaultRules: [true]) {
            LessonViewConfigurationView(lessonViewConfiguration: Group.defaultLessonConfiguration())
        }
    }
}
