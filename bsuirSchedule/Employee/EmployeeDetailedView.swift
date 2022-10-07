//
//  EmployeeDetailedView.swift
//  EmployeeDetailedView
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI
import Combine

struct EmployeeDetailedView: View {
    
    @ObservedObject var viewModel: EmployeeViewModel
    
    var body: some View {
        List {
            Section {
                HStack {
                    photo
                    Spacer()
                    name
                }
            }
            information
            links
            Section {
                lessons
                lastUpdate
            }
            groups
        }
        .overlay {
            ImagesView()
                .environmentObject(viewModel.imagesViewModel)
        }
        .refreshable {
            await viewModel.update()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    FavoriteButton(viewModel.employee.favourite, circle: true) {
                        viewModel.employee.favourite.toggle()
                    }
                } label: {
                    Image(systemName: (viewModel.selectedFaculty == nil && viewModel.selectedEducationType == nil) ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                }
            }
        }
        .navigationTitle(viewModel.employee.lastName!)
    }
    
    @ViewBuilder var photo: some View {
        if let data = viewModel.employee.photo {
            if let photo = UIImage(data: data) {
                Button {
                    viewModel.imagesViewModel.images = [photo]
                    viewModel.imagesViewModel.present(selectedImage: photo)
                } label: {
                    Image(uiImage: photo)
                        .resizable()
                        .frame(width: 80.0, height: 80.0)
                        .clipShape(Circle())
                        .contextMenu {
                            PhotoActionButtons(image: photo)
                        }
                }
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 80.0, height: 80.0)
        }
    }
    
    var name: some View {
        Text(viewModel.employee.firstName! + " " + viewModel.employee.middleName!)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    @ViewBuilder var information: some View {
        if !viewModel.employee.departments!.isEmpty || !viewModel.employee.degree!.isEmpty || viewModel.employee.rank != nil {
            Section("Информация") {
                if !viewModel.employee.departments!.isEmpty {
                    Text("Кафедры: " + (viewModel.employee.departments?.joined(separator: ", "))!)
                }
                
                if !viewModel.employee.degree!.isEmpty {
                    Text("Научаная степень: " + viewModel.employee.degree!)
                }
                if let rank = viewModel.employee.rank {
                    Text("Звание: " + rank)
                }
                
            }
        }
    }
    
    var links: some View {
        Section("Ссылки") {
            Link(destination: URL(string: "https://iis.bsuir.by/departments/employees/" + viewModel.employee.urlID!)!) {
                Label("Контакты", systemImage: "teletype")
            }
            Link(destination: URL(string: "https://iis.bsuir.by/scheduleEmployee/" + viewModel.employee.urlID!)!) {
                Label("Расписание в ИИС", systemImage: "calendar")
            }
        }
    }
    
    @ViewBuilder var lessons: some View {
        if let _ = viewModel.employee.lessons?.allObjects as? [Lesson] {
            NavigationLink {
                LessonsView(viewModel: LessonsViewModel(viewModel.employee))
            } label: {
                Label("Расписание преподавателя", systemImage: "calendar")
            }
        }
    }
    
    @ViewBuilder var lastUpdate: some View {
        HStack {
            Text("Последнее обновление")
            Spacer()
            if let date = viewModel.lastUpdateDate {
                Text("\(DateFormatters.shared.longDate.string(from: date))")
                    .foregroundColor(.secondary)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            }
        }
        .task {
            if viewModel.lastUpdateDate == nil {
                await viewModel.fetchLastUpdateDate()
            }
        }
    }
    
    @ViewBuilder var groups: some View {
        let groups = viewModel.employee.groups
        if groups.isEmpty == false {
            GroupsSectionsView(sections: groups.sections())
        }
    }
}
