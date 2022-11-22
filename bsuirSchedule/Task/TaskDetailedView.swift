//
//  CreateTaskView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 31.10.21.
//

import SwiftUI

struct TaskDetailedView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var viewModel: TaskViewModel
    
    @StateObject var imagesViewModel = ImagesViewModel()
    @State var photoPickerPresented = false
    @State var capturePicturePresented = false
    
    @FocusState var textEditorFocused: Bool
    
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                if viewModel.task == nil {
                    lesson
                }
                deadline
                textEditor
                photos
                endButton
                    .standardisedShadow()
            }
            .padding(.horizontal)
        }
        .overlay {
            ImagesView()
                .padding(.top, 80)
                .ignoresSafeArea(.container, edges: .top)
                .environmentObject(imagesViewModel)
        }
        .navigationTitle((viewModel.task == nil || imagesViewModel.isPresented) ? "" : (viewModel.task!.subject! + " (\(viewModel.task!.lessonType!))"))
        
        .fullScreenCover(isPresented: $capturePicturePresented, onDismiss: { }, content: {
            CapturePhotoView(images: $viewModel.images, isPresented: $capturePicturePresented)
                .ignoresSafeArea(.all, edges: .all)
        })
        .sheet(isPresented: $photoPickerPresented) { } content: {
            PhotoPickerView(images: $viewModel.images, isPresented: $photoPickerPresented)
                .ignoresSafeArea(.all, edges: .bottom)
        }
        
    }
    
    @ViewBuilder var lesson: some View {
        Text(viewModel.lessonDescription())
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
        Divider()
    }
    
    //MARK: Deadline
    
    @ViewBuilder var deadline: some View {

        DisclosureGroup(isExpanded: $viewModel.showDeadline) {
            if viewModel.task == nil {
                DisclosureGroup("Количество пар", isExpanded: $viewModel.showLessonsPicker) {
                    Stepper(value: $viewModel.lessonsPickerValue, in: viewModel.lessonsPickerRange()) {
                        Text(viewModel.lessonsDescription())
                    }
                }
//                .onChange(of: viewModel.lessonsPickerValue, perform: { newValue in viewModel.onLessonsChange(newValue)})
                .onChange(of: viewModel.showLessonsPicker) { newValue in viewModel.onShowLessonsChange(newValue) }
            }

            DisclosureGroup("Дата", isExpanded: $viewModel.showDatePicker) {
                DatePicker(selection: $viewModel.date, label: { })
                    .datePickerStyle(.graphical)
            }
            .onChange(of: viewModel.showDatePicker) { newValue in viewModel.onShowDatePickerChange(newValue) }
        } label: {
            NewHeader(title: viewModel.showDeadline ? "Срок" : viewModel.deadlineDescription(), divider: false)
        }
    }
    
    //MARK: Description
    
    @ViewBuilder var textEditor: some View {
        //        NewHeader(title: "Описание")
        HStack {
            VStack(alignment: .leading) {
                Text("Описание")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
            }
            Spacer()
            if(textEditorFocused) {
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
                        textEditorFocused = false
                    }
                } label: {
                    Circle()
                        .frame(width: 40, height: 40)
                        .shadow(color: .accentColor, radius: 8)
                        .overlay(Image(systemName: "keyboard.chevron.compact.down")
                                    .resizable()
                                    .font(Font.system(.title).bold())
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                        )
                }
                .transition(AnyTransition.scale.animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)))
            }
        }
        Divider()
            .padding(.bottom)
        
        TextEditor(text: $viewModel.text)
            .focused($textEditorFocused)
            .frame(minHeight: 128)
            .cornerRadius(16)
            .mainBackground()
    }
    
    //MARK: Photos
    
    @ViewBuilder var photos: some View {
        NewHeader(title: "Фотографии")
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: []) {
            ForEach(viewModel.images, id: \.self) { image in
                imageView(image)
            }
            addImageButton
            capturePhotoButton
            
        }
    }
    
    func imageView(_ image: UIImage) -> some View {
        Button {
            imagesViewModel.images = viewModel.images
            imagesViewModel.present(selectedImage: image)
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .aspectRatio(contentMode: .fill)
                .mainBackground()
                .overlay {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 104, minHeight: 104)
                        .cornerRadius(16)
                        .clipped()
                }
            
        }.contextMenu {
//            PhotoActionButtons(image: image)
            removeImageButton(image)
        }
    }
    
    //MARK: Context menu buttons
    
    func removeImageButton(_ image: UIImage) -> some View {
        Button(role: .destructive) {
            if let index = viewModel.images.firstIndex(of: image) {
                let _ = withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
                    viewModel.images.remove(at: index)
                }
            }
        } label: {
            Label("Удалить", systemImage: "trash")
        }
    }
    
    //MARK: Big buttons
    
    var addImageButton: some View {
        Button {
            photoPickerPresented = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .mainBackground()
                .aspectRatio(contentMode: .fill)
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.accentColor)
                }
        }
    }
    
    var capturePhotoButton: some View {
        Button {
            capturePicturePresented = true
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .mainBackground()
                .aspectRatio(contentMode: .fill)
                .overlay {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 32)
                        .foregroundColor(.accentColor)
                }
        }
    }
    
    @ViewBuilder var endButton: some View {
        
        Button {
            if viewModel.task != nil {
                viewModel.saveTask()
                presentationMode.wrappedValue.dismiss()
            } else {
                viewModel.createTask()
                presentationMode.wrappedValue.dismiss()
            }
            
        } label: {
            Text(viewModel.task != nil ? "Сохранить" : "Создать")
                .font(.title3)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(40)
        }
        .padding(.vertical)
        .shadow(color: .accentColor, radius: 8)
    }
    
}
