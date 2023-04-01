//
//  ClassroomView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.10.21.
//

import SwiftUI

struct ClassroomView: View {
    @State var classroom: Classroom
    
    var favorite: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(primaryMaterial())
            .aspectRatio(contentMode: .fill)
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(classroom.formattedName(showBuilding: favorite))
                                .font(Font.system(size: 20, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.01)
                                .foregroundColor(Color.primary)
                        }
                        Spacer()
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                if let type = classroom.type {
                                    Text(type.abbreviation)
                                        .foregroundColor(Color.primary)
                                }
                                if let department = classroom.department {
                                    Text(department.abbreviation)
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                        .lineLimit(2)
                                }
                            }
                            Spacer()
                        }
                    }
                    
                }
                .padding()
            }
    }
    
}
