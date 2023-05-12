//
//  EducationTaskView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 12.05.23.
//

import SwiftUI

struct EducationTaskView: View {
    @ObservedObject var educationTask: EducationTask
    @ObservedObject var viewModel: EducationTaskViewModel
    
    init(educationTask: EducationTask) {
        self.educationTask = educationTask
        self.viewModel = EducationTaskViewModel(deadline: educationTask.deadline)
    }
    
    var body: some View {
        SquareTextView(title: educationTask.subject,
                       firstSubtitle: educationTask.note,
                       secondSubtitle: viewModel.deadlineString)
    }
}

struct EducationTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let educationTasks: [EducationTask] = EducationTask.getAll()
        if let educationTask = educationTasks.randomElement() {
            EducationTaskView(educationTask: educationTask)
        }
    }
}
