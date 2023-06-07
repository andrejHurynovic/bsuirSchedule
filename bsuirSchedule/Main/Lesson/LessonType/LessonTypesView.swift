//
//  LessonTypesView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import SwiftUI

struct LessonTypesView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\LessonType.id)],
                  animation: .default)
    var lessonTypes: FetchedResults<LessonType>
    
    var body: some View {
        Form {
            colorsForm
            restoreButton
        }
        .navigationTitle("Типы занятий")
    }
    var colorsForm: some View {
        Section {
            ForEach(lessonTypes, id: \.self) { lessonType in
                LessonTypeConfigurationView(lessonType: lessonType)
            }
        } footer: {
            Text("Изменяйте цвета, названия и аббревиатуры типов занятий")
        }
    }
    
    var restoreButton: some View {
        Section {
            RestoreButton {
                Task {
                    await LessonType.initDefaultLessonTypes()
                }
            }
        } footer: {
            Text("Будут восстановлены цвета, названия и аббревиатуры")
        }
    }
}

struct LessonTypesView_Previews: PreviewProvider {
    static var previews: some View {
        LessonTypesView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

