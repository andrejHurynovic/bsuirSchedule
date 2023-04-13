//
//  GroupsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import SwiftUI

struct GroupsView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Group.id)],
                  animation: .spring())
    var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Faculty.abbreviation)],
                  animation: .spring())
    var faculties: FetchedResults<Faculty>
    @FetchRequest(sortDescriptors: [SortDescriptor(\EducationType.id)],
                  animation: .spring())
    var educationTypes: FetchedResults<EducationType>
    
    @StateObject private var viewModel = GroupsViewModel()
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                GroupsGridView(sections: groups.sections(viewModel.selectedSectionType))
                TotalFooterView(text: "Групп", count: groups.count)
            }
            .navigationTitle("Группы")
            .refreshable { await GroupsViewModel.update() }
            
            .toolbar { toolbar }
            
            .searchable(text: $viewModel.searchText, prompt: "Номер, специальность")
            .onChange(of: viewModel.searchText) { newText in
                groups.nsPredicate = viewModel.calculatePredicate()
            }
            
            .baseBackground()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //    MARK: - Toolbar
    
    @ViewBuilder var toolbar: some View {
        MenuView(defaultRules: viewModel.menuDefaultRules) {
            SortingPicker(value: $viewModel.selectedSectionType)
            facultySelector
            specialtyEducationTypeSelector
            educationDegreeSelector
            courseSelector
        }
    }
    @ViewBuilder var facultySelector: some View  {
        Text("Факультет:")
        Picker("", selection: $viewModel.selectedFaculty) {
            Text("Любой").tag(nil as Faculty?)
            ForEach(faculties
                .filter( {($0.specialities?.allObjects as! [Speciality])
                    .contains(where: { $0.groups?.count != 0 })} ), id: \.self) { faculty in
                        Text(faculty.abbreviation ?? "Без названия")
                            .tag(faculty.self as Faculty?)
                    }
        }
        .onChange(of: viewModel.selectedFaculty) { _ in
            groups.nsPredicate = viewModel.calculatePredicate()
        }
    }
    @ViewBuilder var specialtyEducationTypeSelector: some View  {
        Text("Форма:")
        Picker("", selection: $viewModel.selectedSpecialtyEducationType) {
            Text("Любая").tag(nil as EducationType?)
            ForEach(educationTypes, id: \.self) { educationType in
                Text(educationType.name)
                    .tag(educationType.self as EducationType?)
            }
        }
        .onChange(of: viewModel.selectedSpecialtyEducationType) { _ in
            groups.nsPredicate = viewModel.calculatePredicate()
        }
    }
    @ViewBuilder var educationDegreeSelector: some View  {
        Text("Степень:")
        Picker("", selection: $viewModel.selectedEducationDegree) {
            Text("Любая").tag(nil as EducationDegree?)
            ForEach(EducationDegree.allCases, id: \.self) { degree in
                Text(degree.description)
                    .tag(degree.self as EducationDegree?)
            }
        }
        .onChange(of: viewModel.selectedEducationDegree) { _ in
            groups.nsPredicate = viewModel.calculatePredicate()
        }
    }
    @ViewBuilder var courseSelector: some View  {
        Text("Курс:")
        Picker("", selection: $viewModel.selectedCourse) {
            Text("Любой").tag(nil as Int16?)
            ForEach(1...5, id: \.self) { course in
                Text(String(course))
                    .tag(Int16(course.self) as Int16?)
            }
        }
        .onChange(of: viewModel.selectedCourse) { _ in
            groups.nsPredicate = viewModel.calculatePredicate()
        }
    }
    
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
    
}

