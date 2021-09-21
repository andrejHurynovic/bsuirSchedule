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
                
                if viewModel.employees.isEmpty == false {
                    VStack(alignment: .leading) {
                        Text("Преподаватели")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                List {
                    
                }
            }
            .navigationTitle("Избранные")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct FavoriteGroupView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
        .shadow(color: colorScheme == .dark ? Color(#colorLiteral(red: 255, green: 255, blue: 255, alpha: 0.2)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)), radius: 5, x: 0, y: 0)

    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
