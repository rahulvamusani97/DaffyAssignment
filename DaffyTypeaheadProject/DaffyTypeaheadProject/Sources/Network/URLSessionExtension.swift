//
//  URLSessionExtension.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 15/05/24.
//

import Foundation

extension URLSession: URLSessionProtocol {
    public func createDataTask(with request: URLRequest,
                               completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return ((dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol)
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
