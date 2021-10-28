//
//  ClassroomView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 27.10.21.
//

import SwiftUI

struct ClassroomView: View {
    var classroom: Classroom
    
    var favorite: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.background)
            .aspectRatio(contentMode: .fill)
            .standardizedShadow()
            .overlay {
                HStack {
                    VStack(alignment: .leading) {
                        Text(classroom.formattedName(showBuilding: favorite))
                            .font(Font.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(Color.primary)
                        Spacer()
                        Text(classroom.classroomTypeDescription())
                            .foregroundColor(Color.primary)
                        if let department = classroom.departmentAbbreviation {
                            Text(department)
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundColor(Color.gray)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
    }
}
