//
//  FavoritesView.swift
//  FavoritesView
//
//  Created by Andrej Hurynovič on 21.09.21.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.groups.isEmpty == false {
                    VStack(alignment: .leading) {
                        Text("Группы")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 96, maximum: 256), spacing: nil, alignment: nil)], alignment: .center, spacing: nil, pinnedViews: []) {
                        ForEach(viewModel.groups, id: \.self) {group in
                            ZStack {
                                NavigationLink {
                                    LessonsView(viewModel: LessonsViewModel(group, nil))
                                } label: {
                                    FavoriteGroupView(group: group)
                                }
                            }
                            
                        }
                    }
                    .padding([.leading, .bottom, .trailing])
                }
                
                VStack(alignment: .leading) {
                    Text("Преподаватели")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading)
                }.frame(maxWidth: .infinity, alignment: .leading)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 169, maximum: 256), spacing: nil, alignment: nil)], alignment: .center, spacing: nil, pinnedViews: []) {
//                    ForEach(viewModel.employees, id: \.self) {employee in
                        ZStack {
                            
//                            NavigationLink {
//                                EmployeeDetailedView(employee: employee)
//                            } label: {
//                                VStack(alignment: .leading) {
//                                    Text("Луцик")
//                                        .font(.title3)
//                                        .fontWeight(.bold)
//                                    Text("Юрий Александрович")
//                                    Spacer()
//                                    Text("ЭВМ")
//                                        .font(.headline)
//                                        .fontWeight(.regular)
//                                        .foregroundColor(Color.gray)
//
//                                }
//                                .padding()
//                                .frame(width: 169, height: 112)
//                                .clipped()
//                                .background(in: RoundedRectangle(cornerRadius: 16))
//                                .shadow(radius: 5)
//                            }
                        }
 
//                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Избранные")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct FavoriteGroupView: View {
    var group: Group
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(group.id!)
                .font(.title3)
                .fontWeight(.bold)
            Spacer()
            Text(group.faculty!.abbreviation!)
            Text(String(group.course) + "-й курс")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
            
        }
        .padding()
        .frame(width: 112, height: 112)
        .clipped()
        .background(in: RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 5)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
