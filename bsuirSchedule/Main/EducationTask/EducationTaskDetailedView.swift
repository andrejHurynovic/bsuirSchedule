//
//  EducationTaskDetailedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.10.21.
//

import SwiftUI
import PhotosUI

struct EducationTaskDetailedView: View {
    @StateObject var viewModel: EducationTaskDetailedViewModel
    
    @Environment(\.dismiss) var dismiss
    @FocusState var textEditorFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                deadlinePicker
                textEditor
                imagesGrid
            }
            .padding(.horizontal)
        }
        .navigationTitle(viewModel.educationTask.subject)
        .toolbar { toolbar }
        .baseBackground()
    }
    
    //MARK: - deadlinePicker
    
    var deadlinePicker: some View {
        VStack {
            Toggle("Срок", isOn: $viewModel.withDeadline.animation())
            datePicker
            deadlineDatesPicker
        }
        .padding(8)
        .roundedRectangleBackground(cornerRadius: 8)
    }
    @ViewBuilder var datePicker: some View {
        if viewModel.withDeadline {
            DatePicker("Дата", selection: $viewModel.deadline.animation(),
                       in: Date()...,
                       displayedComponents: [.date, .hourAndMinute])
            
            
        }
    }
    @ViewBuilder var deadlineDatesPicker: some View {
        if let deadlineDates = viewModel.deadlineDates {
            HStack {
                Text("Занятие")
                Spacer()
                Picker("Занятие", selection: $viewModel.deadline.animation()) {
                    ForEach(deadlineDates, id: \.date) { deadlineDate in
                        Text(deadlineDate.title)
                            .id(deadlineDate.title)
                        
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
    
    //MARK: - textEditor
    
    var textEditor: some View {
        Section {
            TextEditor(text: $viewModel.noteText)
                .focused($textEditorFocused)
            
                .frame(minHeight: 38)
                .padding(8)
            
                .scrollContentBackground(.hidden)
                .roundedRectangleBackground(cornerRadius: 8)
        } header: {
            HStack {
                HeaderView("Заметка")
                unfocusTextEditorButton
            }
        }
    }
    @ViewBuilder var unfocusTextEditorButton: some View {
        if textEditorFocused == true {
            Spacer()
            Button {
                withAnimation {
                    textEditorFocused = false
                }
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .bold()
            }
            .padding(.top, 16)
        }
    }
    
    //MARK: - imagesGrid
    
    @ViewBuilder var imagesGrid: some View {
        HeaderView("Изображения")
        SquareGrid {
            photosPicker
            images
        }
    }
    var photosPicker: some View {
        SquareView {
            PhotosPicker(selection: $viewModel.photosPickerItems,
                         matching: .images,
                         photoLibrary: .shared()) {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.accentColor)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    var images: some View {
        ForEach(viewModel.imagesData, id: \.self) { data in
            if let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipped(antialiased: true)
                    .cornerRadius(16)
                    .contextMenu {
                        ShareLink(item: image,
                                  preview: SharePreview("Поделиться изображением",
                                                        image: image))
                        DeleteButton {
                            guard let index = self.viewModel.imagesData.firstIndex(of: data) else { return }
                            let _ = withAnimation {
                                viewModel.imagesData.remove(at: index)
                            }
                        }
                    } preview: {
                        image
                            .resizable()
                    }
            }
        }
    }
    
    //MARK: - Toolbar
    
    var toolbar: some View {
        saveButton
    }
    var saveButton: some View {
        Button("Сохранить") {
            viewModel.save()
            dismiss()
        }
        .bold()
    }
}

class EducationTaskDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let groups: [Group] = Group.getAll()
        if let group = groups.first(where: { $0.name == "250504" }),
           let lessons = group.lessons?.allObjects as? [Lesson],
           let lesson = lessons.randomElement() {
            NavigationView {
                EducationTaskDetailedView(viewModel: EducationTaskDetailedViewModel(lesson: lesson,
                                                                                    lessons: lessons.filtered(abbreviation: lesson.abbreviation)))
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
        }
    }
}
