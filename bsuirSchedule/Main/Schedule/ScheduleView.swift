//
//  ScheduleView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI

struct ScheduleView<ScheduledType: Scheduled>: View where ScheduledType: ObservableObject {
    
    @ObservedObject var scheduled: ScheduledType
    
    @StateObject var viewModel = ScheduleViewModel()
    @StateObject var lessonViewConfiguration = ScheduledType.defaultLessonConfiguration()
    
    @FocusState var searchFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            ZStack(alignment: .center) {
                progressView
                schedule
                    .baseBackground()
            }
            Spacer(minLength: 0)
            searchField
        }
        .environmentObject(lessonViewConfiguration)
        
        .navigationTitle(scheduled.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbar }
        .refreshable {
            if let refreshableObject = scheduled as? (any LessonsRefreshable) {
                let _ = await refreshableObject.update()
            }
        }
        
        .sheet(isPresented: $viewModel.showDatePicker) {
            datePicker
        }
        .sheet(item: $viewModel.selectedHometaskLesson, content: { lesson in
            selectedHometaskSheet(lesson)
        })
        
        .animation(.spring(), value: scheduled.lessons)
        
        .onLoad {
            Task {
                await viewModel.updateSections(scheduled.lessons?.allObjects as? [Lesson])
            }
        }
        .task {
            if let lessonsRefreshable = scheduled as? (any LessonsRefreshable) {
                let _ = await lessonsRefreshable.checkForLessonsUpdates()
            }
        }
        .onChange(of: scheduled.lessons) { lessons in
            Task {
                await viewModel.updateSections(lessons?.allObjects as? [Lesson],
                                               educationDates: scheduled.educationDates)
            }
        }
        .onChange(of: viewModel.selectedSectionType) { _ in
            Task {
                await viewModel.updateSections(scheduled.lessons?.allObjects as? [Lesson],
                                               educationDates: scheduled.educationDates)
            }
        }
    }
    
    @ViewBuilder var schedule: some View {
        if let sections = viewModel.filteredSections,
           sections.isEmpty == false {
            switch viewModel.selectedRepresentationType {
                case .page:
                    page
                case .scroll:
                    scroll
            }
        }
    }
    var page: some View {
        TabView(selection: $viewModel.selectedSectionID) {
            ForEach(viewModel.filteredSections!) { section in
                ScrollView {
                    LessonsGridView {
                        ScheduleSectionView(section: section,
                                            selectedHometaskLesson: $viewModel.selectedHometaskLesson,
                                            showDatePicker: $viewModel.showDatePicker)
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .tabViewStyle(.page(indexDisplayMode: . never))
    }
    var scroll: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                LessonsGridView {
                    ForEach(viewModel.filteredSections!) { section in
                        ScheduleSectionView(section: section,
                                            selectedHometaskLesson: $viewModel.selectedHometaskLesson,
                                            showDatePicker: $viewModel.showDatePicker)
                    }
                }
                .padding(.horizontal)
                .onChange(of: viewModel.selectedSectionID) { targetID in
                    viewModel.scrollTo(targetID,
                                       in: scrollViewProxy)
                }
            }
        }
        .opacity(viewModel.showScrollView ? 1.0 : 0.0)
    }
    
    //MARK: - Progress and footnote
    
    @ViewBuilder var progressView: some View {
        if [viewModel.filteredSections == nil,
            viewModel.filteredSections?.isEmpty,
            viewModel.showScrollView == false].contains(true)  {
            if viewModel.searchText.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.gray))
            } else {
                SearchContentUnavailableView(searchText: viewModel.searchText)
            }
        }
    }
    
    //MARK: - Search field
    
    @ViewBuilder var searchField: some View {
        if viewModel.showSearchField {
            HStack {
                Button {
                    searchFieldFocused = false
                    viewModel.showSearchField = false
                    viewModel.searchText = ""
                } label: {
                    Text("Готово")
                        .bold()
                        .foregroundColor(.primary)
                }
                
                TextField("", text: $viewModel.searchText, prompt: Text(Image(systemName: "magnifyingglass")) + Text(" Предмет"))
                    .focused($searchFieldFocused)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.thinMaterial)
            
        }
        
    }
    
    //MARK: - DatePicker
    
    @ViewBuilder var datePicker: some View {
        ScheduleDatePicker(showDatePicker: $viewModel.showDatePicker,
                           selectedDate: $viewModel.selectedDate,
                           educationRange: scheduled.educationRange)
    }
    
    //MARK: - Toolbar
    
    @ViewBuilder var toolbar : some View {
        searchFieldToggle
        detailedViewNavigationLink
        MenuView(defaultRules: [lessonViewConfiguration == ScheduledType.defaultLessonConfiguration(),
                                viewModel.defaultRules]) {
            FavoriteButton(item: scheduled)
            SectionTypePicker(value: $viewModel.selectedRepresentationType)
            SectionTypePicker(value: $viewModel.selectedSectionType)
            subgroupPicker
            LessonViewConfigurationView(lessonViewConfiguration: lessonViewConfiguration)
        }
    }
    var searchFieldToggle: some View {
        Button {
            searchFieldFocused.toggle()
            viewModel.showSearchField.toggle()
            viewModel.searchText = ""
        } label: {
            Image(systemName: viewModel.showSearchField ? "text.magnifyingglass" : "magnifyingglass")
                .toolbarCircle()
        }
    }
    @ViewBuilder var detailedViewNavigationLink: some View {
        NavigationLink {
            if let group = scheduled as? Group {
                GroupDetailedView(group: group)
            }
            if let employee = scheduled as? Employee {
                EmployeeDetailedView(employee: employee)
            }
            if let auditorium = scheduled as? Auditorium {
                AuditoriumDetailedView(auditorium: auditorium)
            }
        } label: {
            Image(systemName: Constants.Symbols.information)
                .toolbarCircle()
        }
        
    }
    @ViewBuilder var subgroupPicker: some View {
        if ScheduledType.self == Group.self {
            Text("Подгруппа:")
            Picker("", selection: $viewModel.selectedSubgroup.animation()) {
                Text("любая").tag(nil as Int?)
                Text("первая").tag(1 as Int?)
                Text("вторая").tag(2 as Int?)
            }
        }
    }
    
    func selectedHometaskSheet(_ lesson: Lesson) -> some View {
        let lessons = (scheduled.lessons?.allObjects as? [Lesson])!
        let filteredLessons = lessons.filtered(abbreviation: lesson.abbreviation)
        return NavigationView {
            EducationTaskDetailedView(viewModel: EducationTaskDetailedViewModel(lesson: lesson,
                                                                                lessons: filteredLessons))
        }
    }
    
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
//        let groups: [Group] = Group.getAll()
//        if let scheduled = groups.first(where: { $0.name == "950502" }) {
//            NavigationView {
//                ScheduleView(scheduled: scheduled)
//            }
//        }
        let employees: [Employee] = Employee.getAll()
        if let scheduled = employees.first(where: { $0.lastName == "Перцев" }) {
            NavigationView {
                ScheduleView(scheduled: scheduled)
            }
        }
    }
}
