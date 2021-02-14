//
//  NetworkRequestError.swift
//  MediaPocketIos
//
//  Created by Vlad Namashko on 28.12.2020.
//

import Foundation

enum NetworkRequestError: Error {
    case invalidURL(description: String)
    case netConnection(description: String)
    case bodyToJSON(description: String)
    case parsingResponseData(description: String)
    case other(description: String)
}
