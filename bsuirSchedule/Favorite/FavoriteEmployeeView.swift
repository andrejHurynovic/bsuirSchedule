//
//  FavoriteEmployeeView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 28.10.21.
//

import SwiftUI

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
                        .multilineTextAlignment(.leading)
                        .font(Font.system(size: 16))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .foregroundColor(Color.primary)
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
            .standardizedShadow()
        }
    }
}
