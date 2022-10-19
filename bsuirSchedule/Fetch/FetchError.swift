//
//  FetchError.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 26.09.22.
//

import Foundation

enum FetchError: Error {
    case invalidResponse, timeOut, rateLimited, serverBusy, emptyAnswer
}
