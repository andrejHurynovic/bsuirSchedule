//
//  EducationTaskNavigationLink.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 12.05.23.
//

import SwiftUI

struct EducationTaskNavigationLink: View {
    @ObservedObject var educationTask: EducationTask
    
    var body: some View {
        NavigationLink {
            EducationTaskDetailedView(viewModel: EducationTaskDetailedViewModel(educationTask: educationTask))
        } label: {
            EducationTaskView(educationTask: educationTask)
        }
        .contextMenu {
            DeleteButton {
                let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
                guard let backgroundEducationTask = backgroundContext.object(with: educationTask.objectID) as? EducationTask else { return }
                backgroundContext.delete(backgroundEducationTask)
                try? backgroundContext.save()
            }
        }
    }
}

struct EducationTaskNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        let educationTasks: [EducationTask] = EducationTask.getAll()
        if let educationTask = educationTasks.randomElement() {
            EducationTaskNavigationLink(educationTask: educationTask)
        }
    }
}
