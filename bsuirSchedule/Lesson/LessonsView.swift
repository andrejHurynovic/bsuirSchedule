//
//  TimetableView.swift
//  TimetableView
//
//  Created by Andrej Hurynovič on 29.07.21.
//

import SwiftUI

struct LessonsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel: LessonsViewModel
    
    @State var showReturnButton = false
    
    @State var date = Date()
    @State var showDatePicker = false
    
    @State var sectionToScroll: LessonsSection? = nil
    
    @State var showSearchField = false
    @FocusState var searchFieldFocused: Bool
    @State var searchText = ""
    
    @State var taskViewPresented = false
    @StateObject var taskViewModel = TaskViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { proxy in
                    lessons
                        .onLoad(perform: {
                            if let nearSection = viewModel.nearSection {
                                proxy.scrollTo(nearSection.date, anchor: .top)
                            }
                        })
                        .onChange(of: sectionToScroll) { newValue in
                            if let sectionToScroll = newValue {
                                withAnimation {
                                    proxy.scrollTo(sectionToScroll.date, anchor: .top)
                                }
                            }
                            sectionToScroll = nil
                        }
                }
            }
            VStack {
                Spacer()
                bottomMenu
                searchField
                    .onChange(of: searchText) { newValue in
                        sectionToScroll = viewModel.nearSection
                    }
                datePicker
            }
        }
        .navigationBarTitle(viewModel.title ?? "")
        
        .sheet(isPresented: $taskViewPresented, onDismiss: { }, content: {
            TaskDetailedView()
                .environmentObject(taskViewModel)
        })
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
                        showSearchField.toggle()
                        
                        if showSearchField {
                            Task.init(priority: .high) {
                                try await Task.sleep(nanoseconds: UInt64(0.001 * Double(NSEC_PER_SEC)))
                                searchFieldFocused = true
                            }
                        } else {
                            showSearchField = false
                            searchFieldFocused = false
                            searchText.removeAll()
                        }
                    }
                } label: {
                    Image(systemName: showSearchField ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                sortingMenu
            }
        }
    }
    
    
    
    @ViewBuilder var lessons: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: []) {
            ForEach(viewModel.sections, id: \.date) { section in
                let today = (section.date == Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!)
                let lessons: [Lesson] = section.lessons(searchText)
                if lessons.isEmpty == false {
                    Section {
                        ForEach(lessons, id: \.self) { lesson in
                            LessonView(lesson: lesson, showEmployee: viewModel.showEmployees, showGroups: viewModel.showGroups, color: DesignManager.shared.color(lesson.lessonType), showToday: today)
//                                .id(DateFormatters.shared.get(.shortDate).string(from: section.date) + "\(arc4random())")
                                .contextMenu {
                                    Text(lesson.subject)
                                    Button {
                                        //                                        taskViewModel.likeInit(lesson: lesson, lessonsSections: viewModel.sectionsWithLessonsAfterToday(lesson))
                                        taskViewPresented = true
                                    } label: {
                                        Label("Добавить задание", systemImage: "plus")
                                    }
                                }
                        }
                    } header: {
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
                                showDatePicker.toggle()
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                standardizedHeader(title: section.title)
                            }
                        }
                    }
                    .onAppear {
                        if section == viewModel.nearSection {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
                                showReturnButton = false
                            }
                        }
                    }
                    .onDisappear {
                        if section == viewModel.nearSection {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
                                showReturnButton = true
                            }
                        }
                    }
                }
                
                
            }
        }
        .padding()
    }
    
    //MARK: Popup items
    
    @ViewBuilder var searchField: some View {
        if showSearchField {
            TextField("", text: $searchText, prompt: Text(Image(systemName: "magnifyingglass")) + Text(" Предмет"))
                .focused($searchFieldFocused)
                .padding()
                .background(.thinMaterial)
                .clipShape(Capsule())
                .padding([.leading, .bottom, .trailing])
        }
    }
    
    @ViewBuilder var datePicker: some View {
        if showDatePicker {
            DatePicker("", selection: $date, in: viewModel.element.educationRange ?? Date()...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .background(.thinMaterial)
                .cornerRadius(16)
                .foregroundColor(Color.black)
                .padding([.leading, .bottom, .trailing])
            //                .transition(.move(edge: .bottom))
                .transition(.scale)
                .onChange(of: date) { newValue in
                    sectionToScroll = viewModel.nearestSection(newValue)
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.9)) {
                        showDatePicker = false
                    }
                }
            
            
            
        }
    }
    
    //MARK: Bottom menu
    
    @ViewBuilder var bottomMenu: some View {
        HStack {
            returnButton
            Spacer()
            dismissButton
        }
        .padding()
    }
    
    @ViewBuilder var returnButton: some View {
        if showReturnButton {
            Button {
                sectionToScroll = viewModel.nearSection
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .shadow(color: DesignManager.shared.mainColor, radius: 8)
                    .overlay(Image(systemName: "arrow.uturn.backward")
                        .resizable()
                        .font(Font.system(.title).bold())
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    )
            }
            .transition(.scale)
        }
    }
    
    @ViewBuilder var dismissButton: some View {
        if showDatePicker || showSearchField {
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9)) {
                    
                    if showDatePicker{
                        showDatePicker = false
                    }
                    
                    if showSearchField{
                        showSearchField = false
                        searchFieldFocused = false
                        searchText.removeAll()
                    }
                }
            } label: {
                Circle()
                    .frame(width: 48, height: 48)
                    .shadow(color: DesignManager.shared.mainColor, radius: 8)
                    .overlay(Image(systemName: "multiply")
                        .resizable()
                        .font(Font.system(.title).bold())
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                    )
            }
            .transition(.scale)
        }
    }
    
    //MARK: Toolbar
    
    @ViewBuilder var sortingMenu: some View {
        Menu {
            FavoriteButton(viewModel.element.favourite, circle: true) {
                viewModel.element.favourite.toggle()
            }
            
            Text("Отображать:")
            Toggle(isOn: $viewModel.showGroups
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9))) {
                    Text("группы")
                }
            Toggle(isOn: $viewModel.showEmployees
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9))) {
                    Text("преподавателей")
                }
        } label: {
            Image(systemName: (viewModel.checkDefaults()) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
        }
        
    }
    
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView(viewModel: LessonsViewModel(GroupStorage.shared.values.value.first!))
    }
}
