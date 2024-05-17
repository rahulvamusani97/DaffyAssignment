//
//  DaffyURLSession.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 15/05/24.
//

import Foundation
import SystemConfiguration

class DaffyURLSession {
    static var sharedSession = DaffyURLSession()
    private(set) var sessionConfiguration = URLSessionConfiguration.default
    
    private lazy var currentSession: NetworkURLSession = {
        sessionConfiguration.httpMaximumConnectionsPerHost = 10
        sessionConfiguration.timeoutIntervalForRequest = 60
        sessionConfiguration.timeoutIntervalForResource = 60
        let session = NetworkURLSession(configuration: sessionConfiguration)
        return session
    }()
        
    func sendRequest<T: Codable>(_ route: Endpoint, for: T.Type = T.self, completion: @escaping (Result<T, APIError>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            processRequestResponse(route, for: T.self, completion: completion)
            return
        } else {
            showAlert()
        }
    }
    
    func sendRequest(route: Endpoint, completion: @escaping (Result<Data?, APIError>) -> Void) {
        if Reachability.isConnectedToNetwork() {
            processRequestResponse(route, completion: completion)
            return
        } else {
            showAlert()
        }
    }
    
    private func processRequestResponse<T: Codable>(_ route: Endpoint, for: T.Type = T.self, completion: @escaping (Result<T, APIError>) -> Void) {
        currentSession.sendRequest(for: T.self, route, completion: { result in
            switch result {
            case .success(let baseModel):
                completion(.success(baseModel))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func processRequestResponse(_ route: Endpoint, completion: @escaping (Result<Data?, APIError>) -> Void) {
        currentSession.sendRequest(route: route, completion: { result in
            switch result {
            case .success(let baseModel):
                completion(.success(baseModel))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
