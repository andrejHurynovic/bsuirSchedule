//
//  FetchManager.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 18.10.21.
//

import Foundation
import Combine
struct Response<T> {
    let value: T
    let response: URLResponse
}
class FetchManager {
    enum FetchDataType: String {
        case groups = "https://journal.bsuir.by/api/v1/groups"
        case employees = "https://journal.bsuir.by/api/v1/employees"
        case group = "https://journal.bsuir.by/api/v1/studentGroup/schedule?studentGroup="
        case employee = "https://journal.bsuir.by/api/v1/portal/employeeSchedule?employeeId="
        case specialities = "https://journal.bsuir.by/api/v1/specialities"
        case faculties = "https://journal.bsuir.by/api/v1/faculties"
        case classrooms = "https://journal.bsuir.by/api/v1/auditory"
    }
    
    static let shared = FetchManager()
    
    func fetch<T: Decodable>(dataType: FetchDataType, argument: String? = nil, completion: @escaping (T) -> ()) -> AnyCancellable {
        
        let configuration = URLSessionConfiguration.default
        let url: URL!
        
        if dataType == .employee || dataType == .group {
            configuration.timeoutIntervalForRequest = 100
            url = URL(string: dataType.rawValue + argument!)
        } else {
            url = URL(string: dataType.rawValue)
        }

        return URLSession(configuration: configuration)
            .dataTaskPublisher(for: url)
            .share()
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                          throw URLError(.badServerResponse)
                      }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .sink {_ in } receiveValue: { value in
                completion(value)
            }
    }
}
