//
//  EducationBoundedView.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 7.04.23.
//

import SwiftUI

struct EducationBoundedView<EducationDatedType: EducationBounded>: View where EducationDatedType: ObservableObject {
    @ObservedObject var item: EducationDatedType
    
    var body: some View {
        EducationDatesSubview(labelString: "Семестр",
                              firstDate: item.educationStart,
                              lastDate: item.educationEnd)
        EducationDatesSubview(labelString: "Сессия",
                              firstDate: item.examsStart,
                              lastDate: item.examsEnd)
    }
}

private struct EducationDatesSubview: View {
    var labelString: String
    var firstDate: Date?
    var lastDate: Date?
        
    var durationString: String? {
        guard let firstDate = firstDate, let lastDate = lastDate else { return nil }
        return  "\((firstDate...lastDate).numberOfDaysBetween()) дней"
    }
    var rangeString: String? {
        guard let firstDate = firstDate, let lastDate = lastDate else { return nil }
        return [firstDate.formatted(date: .numeric, time: .omitted),
                lastDate.formatted(date: .numeric, time: .omitted)]
            .joined(separator: " - ")
    }
    
    var body: some View {
        if let rangeString = rangeString, let durationString = durationString {
            FormViewWithAlternativeText(labelString,
                                        rangeString,
                                        durationString)
        }
    }
}

struct EducationDatedView_Previews: PreviewProvider {
    static var previews: some View {
        let employees: [Employee] = Employee.getAll()
        if let employee = employees.first(where: {
            [$0.educationStart, $0.educationEnd, $0.examsStart, $0.examsEnd].allSatisfy { $0 != nil }
        }) {
            EducationBoundedView(item: employee)
        }
    }
}
