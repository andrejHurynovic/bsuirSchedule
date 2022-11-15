//
//  LessonsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI

struct LessonsView: View {
    
    @ObservedObject var viewModel: LessonsViewModel
    
    @FocusState var searchFieldFocused: Bool
    
    var body: some View {
        
            ScrollView {
                ScrollViewReader { proxy in
                    lessonsGrid
                        .onChange(of: viewModel.scrollTargetID) { targetSection in
                            viewModel.scrollToID(targetSection, in: proxy)
                        }
                        .onLoad {
                            Task.init {
                                await viewModel.updateSections()
                            }
                        }
                }
            }
            .overlay {
                VStack {
                    Spacer()
                    datePicker
                    searchField
                }
            }
            
        
        .toolbar { toolbar }
        .navigationTitle(viewModel.navigationViewTitle)
    }
    
    var lessonsGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: []) {
            ForEach(viewModel.sections) { section in
                LessonsSectionView(section: section,
                                   showWeeks: viewModel.showWeeks,
                                   showEmployees: viewModel.showEmployees,
                                   showGroups: viewModel.showGroups,
                                   today: viewModel.isToday(section: section),
                                   showDatePicker: $viewModel.showDatePicker)
                
            }
        }
        .padding()
        
    }
    
    //MARK: Search field
    @ViewBuilder var searchField: some View {
        VStack {
            if viewModel.showSearchField {
                HStack {
                    Button {
                        viewModel.searchFieldToggle()
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
                
                .transition(.move(edge: .bottom))
            }
        }
        .onChange(of: viewModel.searchFieldFocusState) { newState in
                searchFieldFocused = newState
        }
        .onChange(of: viewModel.searchText) { newValue in
            viewModel.searchText = newValue
            Task.init {
                await viewModel.updateSections()
            }
        }
            
    }
    
    //MARK: DatePicker
    @ViewBuilder var datePicker: some View {
        if viewModel.showDatePicker,
           let educationRange = viewModel.element.educationRange {
            DatePicker("Выбрать дату:",
                       selection: $viewModel.datePickerDate,
                       in: educationRange,
                       displayedComponents: .date)
            
            .datePickerStyle(.graphical)
            .background(.regularMaterial)
            .cornerRadius(16)
            .padding()
            
            .onChange(of: $viewModel.datePickerDate.wrappedValue) { newDate in
                viewModel.scrollToDate(newDate)
            }
            
            .transition(.move(edge: .bottom))
            .offset(viewModel.datePickerOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        viewModel.onDatePickerGestureChanged(value)
                    }
                    .onEnded{ value in
                        viewModel.onDatePickerGestureEnded(value)
                    }
            )
            
        }
    }
    
    //MARK: Toolbar
    @ViewBuilder var toolbar : some View {
        searchFieldToggle
        detailedViewNavigationLink
        Menu {
            representationModePicker
            subgroupPicker
            Text("Отображать:")
            showWeeksToggle
            showGroupsToggle
            showEmployeesToggle
        } label: {
            Image(systemName: (viewModel.toolbarDefaultCriteria
                               ? "line.3.horizontal.decrease.circle"
                               : "line.3.horizontal.decrease.circle.fill"))
        }
    }
    
    var searchFieldToggle: some View {
        Button {
            viewModel.searchFieldToggle()
        } label: {
            Image(systemName: viewModel.showSearchField ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
        }
    }
    
    var detailedViewNavigationLink: some View {
        NavigationLink {
            if let group = viewModel.element as? Group {
                GroupDetailedView(viewModel: GroupViewModel(group))
            }
            
            if let employee = viewModel.element as? Employee {
                EmployeeDetailedView(viewModel: EmployeeViewModel(employee))
            }
            
            if let classroom = viewModel.element as? Classroom {
                ClassroomDetailedView(classroom: classroom)
            }
            
        } label: {
            Image(systemName: "info.circle")
        }
    }
    
    @ViewBuilder var representationModePicker: some View {
        Text("Отображать по:")
        Picker("", selection: $viewModel.representationMode) {
            ForEach(LessonsSectionRepresentationMode.allCases, id: \.self) { representationMode in
                Text(representationMode.description)
            }
        }
        .onChange(of: $viewModel.representationMode.wrappedValue) { newRepresentationMode in
            viewModel.representationMode = newRepresentationMode
            Task.init {
                await viewModel.updateSections()
            }
        }
    }
    
    @ViewBuilder var subgroupPicker: some View {
        Text("Подгруппа:")
        Picker("", selection: $viewModel.subgroup) {
            Text("любая").tag(nil as Int?)
            Text("первая").tag(1 as Int?)
            Text("вторая").tag(2 as Int?)
        }
        .onChange(of: viewModel.subgroup) { newSubgroup in
            viewModel.subgroup = newSubgroup
            Task.init {
                await viewModel.updateSections()
            }
        }
    }
    
    @ViewBuilder var showWeeksToggle: some View {
        Toggle(isOn: $viewModel.showWeeks
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9))) {
                Text("недели")
            }
    }
    
    @ViewBuilder var showGroupsToggle: some View {
        Toggle(isOn: $viewModel.showGroups
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9))) {
                Text("группы")
            }
    }
    var showEmployeesToggle: some View {
        Toggle(isOn: $viewModel.showEmployees
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.9))) {
                Text("преподавателей")
            }
    }
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        let groups = Group.getAll()
        if let testGroup = groups.first(where: { $0.id == "950502" }) {
            NavigationView {
                LessonsView(viewModel: LessonsViewModel(testGroup))
            }
        }
    }
}
