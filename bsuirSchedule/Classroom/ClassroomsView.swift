//
//  ClassroomsView.swift
//  ClassroomsView
//
//  Created by Andrej Hurynovič on 25.09.21.
//

import SwiftUI

struct ClassroomsView: View {
    @StateObject private var viewModel = ClassroomsViewModel()
    @State var searchText = ""
    
    var body: some View {
        ScrollView {
            Button {
                viewModel.fetchClassrooms()
            } label: {
                Text("SUS")
            }
            
            ForEach(1..<9) { index in
                if let classrooms = viewModel.classrooms.filter({$0.building == index}), classrooms.isEmpty == false {
                    VStack(alignment: .leading) {
                        Text(String(index) + "-ый корпус")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 96, maximum: 256), spacing: nil, alignment: nil)],
                              alignment: .center, spacing: nil,
                              pinnedViews: []) {
                        
                        ForEach(classrooms, id: \.self) {classroom in
                            ZStack {
                                ClassroomView(classroom: classroom)
                            }
                        }
                    }.padding(.horizontal)
                }
            }
        }
    }
}

struct ClassroomView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var classroom: Classroom
    
    var body: some View {
        NavigationLink {
//            LessonsView(viewModel: LessonsViewModel(group, nil))
        } label: {
            VStack(alignment: .leading) {
                Text(classroom.name! + "-" + String(classroom.building))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                Spacer()
                Text(classroom.departmentAbbreviation ?? "")
                    .foregroundColor(Color.primary)
//                Text(String(group.course) + "-й курс")
//                    .font(.headline)
//                    .fontWeight(.regular)
//                    .foregroundColor(Color.gray)
                
            }
        }
        .padding()
        .frame(width: 112, height: 112)
        .clipped()
        .background(in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: colorScheme == .dark ? Color(#colorLiteral(red: 255, green: 255, blue: 255, alpha: 0.2)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)), radius: 5, x: 0, y: 0)
    }
}

struct ClassroomsView_Previews: PreviewProvider {
    static var previews: some View {
        ClassroomsView()
.previewInterfaceOrientation(.portrait)
    }
}
