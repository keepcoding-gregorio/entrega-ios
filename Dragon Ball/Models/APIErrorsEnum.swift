//
//  APIErrorsEnum.swift
//  Dragon Ball
//
//  Created by Gonzalo Gregorio on 30/09/2023.
//

import Foundation

public enum APIErrorsEnum: Error {
    case unknown
    case malformedUrl
    case decodingFailure
    case encodingFailure
    case noData
    case statusCode(code: Int?)
    case noToken
}
