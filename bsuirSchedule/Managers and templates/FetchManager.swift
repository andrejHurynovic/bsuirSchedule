//
//  FetchManager.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 18.10.21.
//

import Foundation
import Combine

class FetchManager {
    
    enum DataTaskError: Error {
        case invalidResponse, timeOut, rateLimited, serverBusy, emptyAnswer
    }
    
    //Взято из https://iis.bsuir.by/api
    enum FetchDataType: String {
        //Неделю в промежутке [1...4]
        case week = "https://iis.bsuir.by/api/v1/schedule/current-week"
        
        case faculties = "https://iis.bsuir.by/api/v1/faculties"
        case specialities = "https://iis.bsuir.by/api/v1/specialities"
        case classrooms = "https://iis.bsuir.by/api/v1/auditories"
        
        case groups = "https://iis.bsuir.by/api/v1/student-groups"
        case group = "https://iis.bsuir.by/api/v1/schedule?studentGroup="
        case groupUpdateDate = "https://iis.bsuir.by/api/v1/last-update-date/student-group?groupNumber="
        case employees = "https://iis.bsuir.by/api/v1/employees/all"
        case employee = "https://iis.bsuir.by/api/v1/employees/schedule/"
        case employeeUpdateDate = "https://iis.bsuir.by/api/v1/last-update-date/employee?url-id="
        
    }
    
    static let shared = FetchManager()
    
    func fetch<T: Decodable>(dataType: FetchDataType, argument: String? = nil, completion: @escaping (T) -> ()) -> AnyCancellable {
        
        #warning("Создать ошибку и хендлить её, если нет аргумента в нужных случаях")
        let url: URL!
        if let argument = argument, [.group, .groupUpdateDate, .employee, .employeeUpdateDate].contains(dataType) {
            url = URL(string: dataType.rawValue + argument)
        } else {
            url = URL(string: dataType.rawValue)
        }
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ dataTaskOutput -> Result<URLSession.DataTaskPublisher.Output, Error> in
                guard let response = dataTaskOutput.response as? HTTPURLResponse else {
                    return .failure(DataTaskError.invalidResponse)
                }
                if response.statusCode == 408 || response.statusCode == 1001{
                    throw DataTaskError.timeOut
                }
                if response.statusCode == 429 {
                    throw DataTaskError.rateLimited
                }
                if response.statusCode == 503 {
                    throw DataTaskError.serverBusy
                }
                if dataTaskOutput.data.count == 0 {
                    //Возникает, когда нет информации о группе.
                    throw DataTaskError.emptyAnswer
                }
                
                return .success(dataTaskOutput)
            })
        
        return dataTaskPublisher
            .catch({ (error: Error) -> AnyPublisher<Result<URLSession.DataTaskPublisher.Output, Error>, Error> in
                switch error {
                case DataTaskError.rateLimited,
                    DataTaskError.serverBusy, DataTaskError.timeOut, URLError.timedOut, URLError.networkConnectionLost:
                    return Fail(error: error)
                        .delay(for: 3, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                case DataTaskError.emptyAnswer:
                    if dataType == .group {
                        Task.init(priority: .high, operation: {
                            GroupStorage.shared.delete(id: argument ?? "")
                        })
                    }
                    return Just(.failure(error))
                        .receive(on: DispatchQueue.main)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                default:
                    return Just(.failure(error))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            })
                .retry(4)
                .receive(on: DispatchQueue.main)
                .tryMap({ result in
                    return try result.get().data
                })
                    .decode(type: T.self, decoder: JSONDecoder())
                    .sink {_ in } receiveValue: { value in
                        completion(value)
                    }
        
    }
}
