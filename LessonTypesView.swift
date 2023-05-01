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
            ForEach(lessonTypes, id: \.self) { lessonType in
                LessonTypeConfigurationView(lessonType: lessonType)
            }
        }
        .navigationTitle("Типы занятий")
    }
}

struct LessonTypesView_Previews: PreviewProvider {
    static var previews: some View {
        LessonTypesView()
    }
}
func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

