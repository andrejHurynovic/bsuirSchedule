//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    
    @AppStorage("primaryGroup") var primaryGroup: String?
    
    @State var primaryGroupPresented = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if let primaryGroup = primaryGroup {
                    if let group = viewModel.groups.first{$0.id == primaryGroup} {
                        NavigationLink(destination: LessonsView(viewModel: LessonsViewModel(group)), isActive: $primaryGroupPresented) {
                            EmptyView()
                        }
                        .hidden()
                        .onLoad {
                            primaryGroupPresented = true
                        }
                    }
                }
                
                if viewModel.groups.isEmpty == false {
                    groups
                }
                
                
            }
            .navigationTitle("Избранные")
        }
    }
    
    
    @ViewBuilder var groups: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 104, maximum: 256))], alignment: .center, spacing: 8, pinnedViews: []) {
            ForEach(viewModel.groups) { group in
                NavigationLink {
                    LessonsView(viewModel: LessonsViewModel(group))
                } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.background)
                    .aspectRatio(contentMode: .fill)
                    .shadow(color: .secondary, radius: 6, x: 0, y: 0)
                    .overlay {
                            VStack(alignment: .leading) {
                                Text(group.id!)
                                    .font(Font.system(size: 500, weight: .bold))
                                    .minimumScaleFactor(0.01)
                                    .foregroundColor(Color.primary)
                                Spacer()
                                Text(group.speciality!.abbreviation!)
                                    .foregroundColor(Color.primary)
                                HStack {
                                    Text(String(group.speciality!.faculty!.abbreviation!))
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                    Spacer()
                                    Image(systemName: String(group.course) + ".circle.fill")
                                        .foregroundColor(Color.gray)
                                }
                            }
                            .padding(14)
                        
                    }
                    .contextMenu {
                        Button {
                            withAnimation {
                                viewModel.removeFromFavorites(group)
                            }
                            
                        } label: {
                            Label("Убрать из избранных", systemImage: "star.slash")
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .preferredColorScheme(.dark)
    }
}

struct EmployeeFavoriteView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var employee: Employee
    
    var body: some View {
        NavigationLink {
            EmployeeDetailedView(employee: employee)
        } label: {
            HStack {
                if let photo = employee.photo {
                    Image(uiImage: UIImage(data: photo)!)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                //                                Spacer()
                VStack(alignment: .leading) {
                    Text(employee.lastName ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(employee.firstName! + " " + employee.middleName!)
                }
                .foregroundColor(Color.primary)
                Spacer()
                VStack() {
                    if !employee.departments!.isEmpty {
                        Text(employee.departments!.joined(separator: ", \n"))
                            .foregroundColor(Color.gray)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .padding()
            .clipped()
            .background(in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: colorScheme == .dark ? Color(#colorLiteral(red: 255, green: 255, blue: 255, alpha: 0.2)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)), radius: 5, x: 0, y: 0)
        }
    }
}
