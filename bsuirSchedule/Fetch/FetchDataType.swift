//
//  FetchDataType.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 26.09.22.
//

//https://iis.bsuir.by/api
enum FetchDataType: String {
    case faculties = "https://iis.bsuir.by/api/v1/faculties"
    case specialities = "https://iis.bsuir.by/api/v1/specialities"
    case auditoriums = "https://iis.bsuir.by/api/v1/auditories"
    case departments = "https://iis.bsuir.by/api/v1/departments"
    
    case groups = "https://iis.bsuir.by/api/v1/student-groups"
    case group = "https://iis.bsuir.by/api/v1/schedule?studentGroup="
    case groupUpdateDate = "https://iis.bsuir.by/api/v1/last-update-date/student-group?groupNumber="
    
    case employees = "https://iis.bsuir.by/api/v1/employees/all"
    case employee = "https://iis.bsuir.by/api/v1/employees/schedule/"
    case employeeUpdateDate = "https://iis.bsuir.by/api/v1/last-update-date/employee?url-id="
}
