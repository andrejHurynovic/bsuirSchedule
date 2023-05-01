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
    
    @State private var showingRestoreDefault: Bool = false
    
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
        } header: {
            Text("Цвета")
        } footer: {
            Text("Изменяйте цвета, названия и аббревиатуры типов занятий")
        }
    }
    
    var restoreButton: some View {
        Section {
            Button {
                showingRestoreDefault = true
            } label: {
                Label("Сбросить", systemImage: "arrow.uturn.left.circle")
                    .foregroundColor(.red)
            }.alert("Вы уверены?", isPresented: $showingRestoreDefault) {
                Button ("Сбросить", role: .destructive) {
                    Task{
                        await LessonType.initDefaultLessonTypes()
                    }
                }
                Button ("Отмена", role: .cancel) {}
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

