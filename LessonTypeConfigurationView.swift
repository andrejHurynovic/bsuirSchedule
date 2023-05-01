//
//  LessonTypeConfigurationView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import SwiftUI

struct LessonTypeConfigurationView: View {
    @ObservedObject var lessonType: LessonType
    
    var body: some View {
        DisclosureGroup(lessonType.id) {
            TextField("Название", text: $lessonType.name ?? "", prompt: Text("Название"))
            TextField("Аббриветатура", text: $lessonType.abbreviation ?? "", prompt: Text("Аббриветатура"))
            ColorPicker("Цвет", selection: $lessonType.color ?? .primary)
        }
        .onSubmit {
            let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
            
            guard let backgroundLessonType = backgroundContext.object(with: lessonType.objectID) as? LessonType else { return }
            if lessonType.name?.isEmpty == false {
                backgroundLessonType.name = lessonType.name
            } else {
                backgroundLessonType.name = nil
            }
            if lessonType.abbreviation?.isEmpty == false {
                backgroundLessonType.abbreviation = lessonType.abbreviation
            } else {
                backgroundLessonType.abbreviation = nil
            }
            
            try! backgroundContext.save()
        }
        .onChange(of: lessonType.color) { newColor in
            let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
            
            guard let backgroundLessonType = backgroundContext.object(with: lessonType.objectID) as? LessonType else { return }
            backgroundLessonType.color = newColor
            
            try! backgroundContext.save()
        }
    }
}

struct LessonTypeConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        let lessonTypes = LessonType.getAll()
        
        Form {
            ForEach(lessonTypes, id: \.self) { lessonType in
                LessonTypeConfigurationView(lessonType: lessonType)
            }
        }
        
    }
}
