//
//  CompoundSchedulePickerSheet.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 14.06.23.
//

import SwiftUI

struct CompoundSchedulePickerSheet: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\CompoundSchedule.name)],
                  animation: .spring())
    var compoundSchedules: FetchedResults<CompoundSchedule>
    @EnvironmentObject var compoundSchedulePickerViewModel: CompoundSchedulePickerViewModel
    
    @State var text: String = ""
    @FocusState var textFieldFocus
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Добавить новое", text: $text)
                    .onSubmit {
                        onTextFiledSubmit()
                    }
                ForEach(compoundSchedules) { schedule in
                    let contains = schedule.allScheduled.contains {
                        guard let selectedCompoundScheduled = compoundSchedulePickerViewModel.selectedCompoundScheduled else { return false }
                        if $0.objectID == selectedCompoundScheduled.objectID {
//                            print("sus true")
                        } else {
//                            print("sus false")
                        }
                        return $0.objectID == selectedCompoundScheduled.objectID
                    }
                    let _ = print(contains)
                    Button {
                        Task {
                            let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
                            guard let selectedCompoundScheduled = compoundSchedulePickerViewModel.selectedCompoundScheduled,
                                  let backgroundCompoundScheduled = backgroundContext.object(with: selectedCompoundScheduled.objectID) as? any CompoundScheduled,
                                  let backgroundCompoundSchedule = backgroundContext.object(with: schedule.objectID) as? CompoundSchedule else {
                                return
                            }
                            if contains {
                                backgroundCompoundScheduled.removeFromCompoundSchedules(backgroundCompoundSchedule)
                            } else {
                                backgroundCompoundScheduled.addToCompoundSchedules(backgroundCompoundSchedule)
                            }
                            
                            try? backgroundContext.save()
                        }
//                        compoundSchedulePickerViewModel.showCompoundSchedulePickerSheet = false
                    } label: {
                        Label(schedule.title, systemImage: contains ? "circle.fill" : "circle")
                    }
                    
                }
            }
            .navigationTitle("Сомещённые")
            .toolbar { toolbar }
        }
        
    }
    
    var toolbar: some View {
        Button("Готово") {
            compoundSchedulePickerViewModel.showCompoundSchedulePickerSheet = false
        }
    }
    
    func onTextFiledSubmit() {
        let text = text
        Task {
            let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
            let newCompoundSchedule = CompoundSchedule(context: backgroundContext)
            newCompoundSchedule.name = text
            try? backgroundContext.save()
        }
        self.text = ""
        textFieldFocus = false
    }
}

//struct CompoundSchedulePicketSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        CompoundSchedulePickerSheet(selectedScheduled: nil)
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}
