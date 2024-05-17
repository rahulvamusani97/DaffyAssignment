//
//  APIError.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 15/05/24.
//

import Foundation

public enum APIError: Error {
    case requestFailed(Error?, [String: Any]? = nil)
    case invalidData
    case jsonParsingFailure
    case buildRequestFailed
    case clientError(Int?, Error?, Data? = nil)
    case serverError(Int?, Error?, Data? = nil)
    case noInternetError(Error?)
}
