//
//  EmployeeView.swift
//  EmployeeView
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI

struct EmployeeView: View {
    var employee: Employee
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(employee.lastName!)
                    .font(.title)
                    .fontWeight(.bold)
                Text(employee.firstName! + " " + employee.middleName!)
                if !employee.departments!.isEmpty {
                    Text(employee.departments!.joined(separator: ", "))
                        .foregroundColor(Color.gray)
                }
            }
            Spacer()
            if let photo = employee.photo {
                Image(uiImage: photo)
                    .resizable()
                    .frame(width: 80.0, height: 80.0)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 80.0, height: 80.0)
//                    .onAppear {
//                        if let photoURL = employee.photoLink {
//                            URLSession(configuration: .default).dataTask(with: URL(string: photoURL)!) { data, response, error in
//                                employee.photo = UIImage(data: data!)
//                                if employee.photo == nil {
//                                    employee.photoLink = nil
//                                }
//                            }.resume()
//                        }
//                    }
            }
        }
    }
}
