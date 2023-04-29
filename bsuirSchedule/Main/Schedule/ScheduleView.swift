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
    @StateObject var lessonViewSettings = ScheduledType.defaultLessonSettings()
    
    @FocusState var searchFieldFocused: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            progressView
            scrollView
            searchField
        }
        .sheet(isPresented: $viewModel.showDatePicker) {
            datePicker
                .presentationDetents([.medium])
        }

        
        .navigationTitle(scheduled.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbar }
        .refreshable {
            if let refreshableObject = scheduled as? (any LessonsRefreshable) {
                let _ = await refreshableObject.update()
            }
        }
        
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
                await viewModel.updateSections(lessons?.allObjects as? [Lesson])
            }
        }
        .onChange(of: viewModel.selectedSectionType) { _ in
            Task {
                await viewModel.updateSections(scheduled.lessons?.allObjects as? [Lesson])
            }
        }
    }
    
    var scrollView: some View {
        ScrollView {
            ScrollViewReader { scrollViewProxy in
                lessonsGrid
                    .onChange(of: viewModel.targetSection) { targetSection in
                        viewModel.scrollTo(section: targetSection,
                                           in: scrollViewProxy)
                    }
            }
        }
        .opacity(viewModel.showScrollView ? 1.0 : 0.0)
        .baseBackground()
    }
    
    //MARK: - Lessons grid
    
    @ViewBuilder var lessonsGrid: some View {
        if let sections = viewModel.filteredSections,
           sections.isEmpty == false {
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: []) {
                ForEach(sections) { section in
                    ScheduleSectionView(section: section,
                                        lessonViewSettings: lessonViewSettings,
                                        showDatePicker: $viewModel.showDatePicker)
                }
            }
            .padding(.horizontal)
        }
        
    }
    
    //MARK: - Progress and footnote
    
    @ViewBuilder var progressView: some View {
        if [viewModel.sections == nil,
            viewModel.sections?.isEmpty,
            viewModel.showScrollView == false].contains(true)  {
            if viewModel.searchText.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.primary))
            } else {
                Text("Занятия по таким параметрам отсутствуют"
                    .uppercased())
                .multilineTextAlignment(.center)
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
            }
        }
    }
    
    //MARK: - Search field
    
    @ViewBuilder var searchField: some View {
        VStack {
            Spacer()
            VStack {
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
        }
        
    }
    
    //MARK: - DatePicker
    
    @ViewBuilder var datePicker: some View {
        if viewModel.showDatePicker,
           let educationRange = scheduled.educationRange {
            DatePicker("Выбор даты:",
                       selection: $viewModel.selectedDate,
                       in: educationRange,
                       displayedComponents: .date)
            
            .datePickerStyle(.graphical)
            .padding()
        }
        Button {
            viewModel.showDatePicker = false
        } label: {
            Text("Готово")
                .font(.title3)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(40)
        }
        .padding([.horizontal, .bottom])
    }
    
    //MARK: - Toolbar
    
    @ViewBuilder var toolbar : some View {
        searchFieldToggle
        detailedViewNavigationLink
        MenuView(defaultRules: [lessonViewSettings == ScheduledType.defaultLessonSettings(),
                                viewModel.defaultRules]) {
            FavoriteButton(item: scheduled)
            SectionTypePicker(value: $viewModel.selectedSectionType)
            subgroupPicker
            lessonSettings
        }
    }
    var searchFieldToggle: some View {
        Button {
            searchFieldFocused.toggle()
            viewModel.showSearchField.toggle()
            viewModel.searchText = ""
        } label: {
            Image(systemName: viewModel.showSearchField ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
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
            Image(systemName: "info.circle")
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
            .onChange(of: viewModel.selectedSubgroup) { _ in
                viewModel.updateFilteredSections()
            }
        }
    }
    @ViewBuilder var lessonSettings: some View {
        Text("Отображать:")
        Toggle("Аббревиатуру", isOn: $lessonViewSettings.showAbbreviation.animation())
        Toggle("Группы", isOn: $lessonViewSettings.showGroups.animation())
        Toggle("Преподавателей", isOn: $lessonViewSettings.showEmployees.animation())
        Toggle("Недели", isOn: $lessonViewSettings.showWeeks.animation())
        Toggle("Период", isOn: $lessonViewSettings.showDates.animation())
        Toggle("Дату", isOn: $lessonViewSettings.showDate.animation())
    }
    
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = Group.getAll()
        if let testGroup = groups.first(where: { $0.name == "050502" }) {
            NavigationView {
                ScheduleView(scheduled: testGroup)
            }
        }
    }
}
