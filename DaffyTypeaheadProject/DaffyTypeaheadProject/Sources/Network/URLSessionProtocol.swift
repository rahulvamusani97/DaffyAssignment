//
//  URLSessionProtocol.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 15/05/24.
//

import Foundation

public protocol URLSessionDataTaskProtocol {
    func resume()
}

public protocol URLSessionProtocol: AnyObject {
    func createDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}
