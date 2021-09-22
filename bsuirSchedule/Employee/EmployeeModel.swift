//
//  EmployeeModel.swift
//  EmployeeModel
//
//  Created by Andrej Hurynovič on 13.09.21.
//

import UIKit

struct EmployeeModel: Decodable {
    
    public var id: Int32?
    public var urlID: String?
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    
    public var educationStart: Date?
    public var educationEnd: Date?
    public var examsStart: Date?
    public var examsEnd: Date?
    
    public var rank: String?
    public var degree: String?
    public var departments: [String]?
    public var favorite: Bool
    
    public var photoLink: String?
    
    public var lessons: [Lesson] = []

    
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? container.decode(Int32.self, forKey: .id)
        self.urlID = try? container.decode(String.self, forKey: .urlID)
        self.firstName = try? container.decode(String.self, forKey: .firstName)
        self.middleName = try? container.decode(String.self, forKey: .middleName)
        self.lastName = try? container.decode(String.self, forKey: .lastName)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        if let educationStartString = try? container.decode(String.self, forKey: .educationStart) {
            self.educationStart = dateFormatter.date(from: educationStartString)
            self.educationEnd = dateFormatter.date(from: try! container.decode(String.self, forKey: .educationEnd))
        }
        if let examsStartString = try? container.decode(String.self, forKey: .examsStart) {
            self.examsStart = dateFormatter.date(from: examsStartString)
            self.examsEnd = dateFormatter.date(from: try! container.decode(String.self, forKey: .examsEnd))
        }
        
        self.rank = try? container.decode(String.self, forKey: .rank)
        self.degree = try? container.decode(String.self, forKey: .degree)
        if var departments = try? container.decode([String].self, forKey: .departments) {
            departments.forEach { department in
                if let range = department.range(of: "каф.") {
                    department.removeSubrange(range)
                }
                department = department.trimmingCharacters(in: .whitespaces)
            }
            self.departments = departments
        }
        self.favorite = false
        
        self.photoLink = try? container.decode(String.self, forKey: .photoLink)
        
        if let schedules = try? container.decode([Schedule].self, forKey: .lessons) {
            schedules.forEach { schedule in
                switch schedule.weekDay {
                case .Monday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 0
                    }
                case .Tuesday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 1
                    }
                case .Wednesday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 2
                    }
                case .Thursday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 3
                    }
                case .Friday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 4
                    }
                case .Saturday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 5
                    }
                case .Sunday:
                    schedule.lessons.forEach { lesson in
                        lesson.weekDay = 6
                    }
                    
                    
                case .none:
                    break
                }
                
                lessons.append(contentsOf: schedule.lessons)
                
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case urlID = "urlId"
        case firstName
        case middleName
        case lastName
        
        case educationStart = "dateStart"
        case educationEnd = "dateEnd"
        case examsStart = "sessionStart"
        case examsEnd = "sessionEnd"
        
        case departments = "academicDepartment"
        case rank
        case degree
        
        case photoLink
        
        case lessons = "schedules"
    }
}

