//
//  FetchError.swift
//  bsuirSchedule
//
//  Created by Andrej Hurynovič on 26.09.22.
//

enum FetchError: Error {
    case invalidResponse, timeOut, rateLimited, serverBusy, emptyAnswer
}
