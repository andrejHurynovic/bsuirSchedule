//
//  EmployeeModel.swift
//  EmployeeModel
//
//  Created by Andrej Hurynovič on 13.09.21.
//

import UIKit

struct EmployeeModel: Decodable {
    
    public var id: Int32
    public var urlID: String?
    public var firstName: String?
    public var middleName: String?
    public var lastName: String?
    
    public var rank: String?
    public var degree: String?
    public var departments: [String]?
    public var favorite: Bool
    
    public var photoLink: String?
    
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try! container.decode(Int32.self, forKey: .id)
        self.urlID = try? container.decode(String.self, forKey: .urlID)
        self.firstName = try? container.decode(String.self, forKey: .firstName)
        self.middleName = try? container.decode(String.self, forKey: .middleName)
        self.lastName = try? container.decode(String.self, forKey: .lastName)
        
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
       
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case urlID = "urlId"
        case firstName
        case middleName
        case lastName
        
        case departments = "academicDepartment"
        case rank
        case degree
        
        case photoLink
    }
}

