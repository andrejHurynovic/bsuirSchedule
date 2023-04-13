//
//  EmployeeView.swift
//  EmployeeView
//
//  Created by Andrej Hurynovič on 8.09.21.
//

import SwiftUI

struct EmployeeView: View {
    @ObservedObject var employee: Employee
    
    var showTitle: Bool = true
    var showDepartments: Bool = false
    var imageSize: CGFloat {
        let baseSize = 44.0
        let departmentsTextHeight = 20.0
        return showDepartments ? (baseSize + departmentsTextHeight) : baseSize
    }
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            text
            Spacer()
            image
                .transition(.scale.combined(with: .opacity))
        }
        .foregroundColor(.primary)
    }
    
    //MARK: - Text
    
    var text: some View {
        VStack(alignment: .leading) {
            title
            firstSubtitle
            secondSubtitle
        }
        .lineLimit(1)
        .minimumScaleFactor(0.25)
    }
    
    @ViewBuilder var title: some View {
        if showTitle {
            VStack(alignment: .leading) {
                Text(employee.lastName)
                    .font(.system(.title3,
                                  design: .rounded,
                                  weight: .bold))
            }
        }
    }
    var firstSubtitle: some View {
        Text(employee.formattedName)
            .font(.system(.body,
                          design: .rounded))
    }
    @ViewBuilder var secondSubtitle: some View {
        if showDepartments,
           let departmentsAbbreviations = employee.departmentsAbbreviations {
            Text(departmentsAbbreviations.joined(separator: ", "))
                .font(.system(.body,
                              design: .rounded))
                .foregroundColor(Color.gray)
        }
    }
    
    //MARK: - Image
    
    @ViewBuilder var image: some View {
        if let _ = employee.photo {
            photo
        } else {
            photoPlaceholder
        }
    }
    var photo: some View {
        Image(uiImage: UIImage(data: employee.photo!)!)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .clipShape(Circle())
    }
    var photoPlaceholder: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: imageSize, height: imageSize)
    }
    
}

struct EmployeeView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeesView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
