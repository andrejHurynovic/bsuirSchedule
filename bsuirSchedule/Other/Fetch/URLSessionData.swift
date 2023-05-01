//
//  URLSessionData.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 1.05.23.
//

import Foundation

extension URLSession {
    func data(for dataType: FetchDataType, with argument: String? = "") async throws -> Data? {
        guard let url = URL(string: argument == nil ? dataType.rawValue : dataType.rawValue + argument!) else {
            Log.error("Can't create url for \(dataType), argument: \(String(describing: argument))")
            throw URLError(.badURL)
        }
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard data.isEmpty == false else {
            Log.error("Can't get data from \(dataType), argument: \(String(describing: argument)), urlResponse: \(urlResponse)")
            return nil
        }
        
        return data
    }
    
    func data(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
