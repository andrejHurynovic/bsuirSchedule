//
//  FetchManager.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 18.10.21.
//

import Foundation
import Combine

class FetchManager {
    
    static let shared = FetchManager()
    ///Creates cancellable with data task of fetching data
    ///Argument is required for group, employee and updateDates
    func fetch<T: Decodable>(dataType: FetchDataType, argument: String? = nil, completion: @escaping (T) -> ()) -> AnyCancellable {
        
        let url: URL!
        //Adds argument if it's specified
        if let argument = argument, [.group, .groupUpdateDate, .employee, .employeeUpdateDate].contains(dataType) {
            url = URL(string: dataType.rawValue + argument)
        } else {
            url = URL(string: dataType.rawValue)
        }
        
        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ dataTaskOutput -> Result<URLSession.DataTaskPublisher.Output, Error> in
                guard let response = dataTaskOutput.response as? HTTPURLResponse else {
                    return .failure(FetchError.invalidResponse)
                }
                if response.statusCode == 408 || response.statusCode == 1001{
                    throw FetchError.timeOut
                }
                if response.statusCode == 429 {
                    throw FetchError.rateLimited
                }
                if response.statusCode == 503 {
                    throw FetchError.serverBusy
                }
                if dataTaskOutput.data.count == 0 {
                    throw FetchError.emptyAnswer
                }
                
                return .success(dataTaskOutput)
            })
        
        return dataTaskPublisher
            .catch({ (error: Error) -> AnyPublisher<Result<URLSession.DataTaskPublisher.Output, Error>, Error> in
                //MARK: Error handler
                switch error {
                case FetchError.rateLimited,
                    FetchError.serverBusy, FetchError.timeOut, URLError.timedOut, URLError.networkConnectionLost:
                    return Fail(error: error)
                        .delay(for: 3, scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                
                case FetchError.emptyAnswer:
                    //If there is no information about group it will be deleted.
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
