//
//  LessonsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 19.10.22.
//

import SwiftUI

struct LessonsView: View {
    
    @ObservedObject var viewModel: LessonsViewModel
    
    var body: some View {
        
            ScrollView {
                ScrollViewReader { proxy in
                    sections
                        .onChange(of: viewModel.targetSection) { targetSection in
                            viewModel.scrollToSection(targetSection, in: proxy)
                        }
                        .onLoad{
                            Task.init {
                                await MainActor.run {
                                    viewModel.sections = viewModel.element.dateBasedLessonsSections()
                                    viewModel.currentTimeSection = viewModel.nearestSection(to: Date())
                                }
                                viewModel.scrollToSection(viewModel.currentTimeSection, in: proxy)

                            }
                        }
                }
            }.overlay {
                VStack {
                    Spacer()
//                    searchField
                    datePicker
                }
            }
            
        
        .toolbar {toolbar}
        .navigationTitle(viewModel.navigationViewTitle)
    }
    
    var sections: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 240, maximum: 500))], alignment: .leading, spacing: 8, pinnedViews: []) {
            ForEach(viewModel.sections) { section in
                LessonsSectionView(section: section,
                                       showEmployees: viewModel.showEmployees,
                                       showGroups: viewModel.showGroups,
                                       showDatePicker: $viewModel.showDatePicker)
                
            }
        }
        .padding()
        
    }
    
    //MARK: Search field
    @ViewBuilder var searchField: some View {
        if viewModel.showDatePicker {
            
//            Capsule()
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
            .background(.thinMaterial)
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
        detailedViewNavigationLink
        Menu {
            Text("Отображать по:")
            representationModeToggle
            Text("Отображать:")
            showGroupsToggle
            showEmployeesToggle
        } label: {
            Image(systemName: (viewModel.toolbarDefaultCriteria
                               ? "line.3.horizontal.decrease.circle"
                               : "line.3.horizontal.decrease.circle.fill"))
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
    
    var representationModeToggle: some View {
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
    var showGroupsToggle: some View {
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

