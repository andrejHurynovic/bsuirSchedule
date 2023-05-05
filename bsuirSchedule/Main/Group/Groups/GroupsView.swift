//
//  GroupsView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 11.04.23.
//

import SwiftUI

struct GroupsView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\Group.name)],
                  animation: .spring())
    private var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: [SortDescriptor(\Faculty.abbreviation)],
                  animation: .spring())
    private var faculties: FetchedResults<Faculty>
    @FetchRequest(sortDescriptors: [SortDescriptor(\EducationType.id)],
                  animation: .spring())
    private var educationTypes: FetchedResults<EducationType>
    
    @StateObject private var viewModel = GroupsViewModel()
    
    //MARK: - Body
    
    var body: some View {
            ScrollView {
                GroupsGridView(sections: groups.sections(viewModel.selectedSectionType))
                TotalFooterView(text: "Групп", count: groups.count)
            }
            .navigationTitle("Группы")
            .refreshable { await GroupsViewModel.update() }
            
            .toolbar { toolbar }
            
            .searchable(text: $viewModel.searchText, prompt: "Номер, специальность")
            .onChange(of: viewModel.predicate) { groups.nsPredicate = $0 }
            
            .baseBackground()
    }
    
    //    MARK: - Toolbar
    
    @ViewBuilder var toolbar: some View {
        MenuView(defaultRules: viewModel.menuDefaultRules) {
            SectionTypePicker(value: $viewModel.selectedSectionType)
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
    }
    
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GroupsView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
    
}

