//
//  APIClient.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 15/05/24.
//

import Foundation

public typealias Completion<T: Codable> = (Result<T, APIError>) -> Void

protocol APIClient {
    var session: URLSessionProtocol! { get }
    var task: URLSessionDataTaskProtocol? { get set }
    
    mutating func sendRequest<T: Codable>(for: T.Type, _ route: Endpoint, completion: @escaping (Result<T, APIError>) -> Void)
    mutating func sendRequest(route: Endpoint, completion: @escaping (Result<Data?, APIError>) -> Void)
}

extension APIClient {
    mutating func sendRequest<T: Codable>(for: T.Type,
                                          _ route: Endpoint,
                                          completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            if let request = try self.buildRequest(from: route) {
                task = decodingTask(with: request, decodingType: T.self, completionHandler: completion)
            }
        } catch {
            completion(.failure(.buildRequestFailed))
        }
        self.task?.resume()
    }
    
    mutating func sendRequest(route: Endpoint, completion: @escaping (Result<Data?, APIError>) -> Void) {
            do {
                if let request = try self.buildRequest(from: route) {
                    task = decodingTask(with: request, completionHandler: completion)
                }
            } catch {
                completion(.failure(.buildRequestFailed))
            }
            self.task?.resume()
        }
    
    func buildRequest(from route: Endpoint) throws -> URLRequest? {
        guard let url = route.url else { return nil }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        request.httpMethod = route.method.rawValue
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
}

extension APIClient {
    mutating func decodingTask<T: Codable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping (Result<T, APIError>) -> Void) -> URLSessionDataTaskProtocol {
        var strongSelf = self
        let task = session.createDataTask(with: request) { data, response, error in
            strongSelf.handleResponse(withData: data, decodingType: decodingType, httpResponse: response, error: error, completionHandler: completion)
        }
        return task
    }
    
    mutating func decodingTask(with request: URLRequest, completionHandler completion: @escaping (Result<Data?, APIError>) -> Void) -> URLSessionDataTaskProtocol {
        let task = session.createDataTask(with: request) { data, response, error in
            completion(.success(data))
        }
        return task
    }
    
    mutating func handleResponse<T: Codable>(withData data: Data?, decodingType: T.Type, httpResponse: URLResponse?, error: Error? = nil, completionHandler completion: @escaping Completion<T>) {
        if let error = error, error.localizedDescription == "cancelled" {
            completion(Result.failure(.invalidData))
            return
        }
        guard let httpResponse = httpResponse as? HTTPURLResponse else {
            if let nsError = error as? NSError, (nsError.code == -1009 || nsError.code == -1004 || nsError.code == -1001 || nsError.code == -1020 || nsError.code == -1003) {
                completion(Result.failure(APIError.noInternetError(error)))
                return
            }
            completion(Result.failure(.invalidData))
            return
        }
        
        let result = handleNetworkResponse(data, httpResponse, error: error)
        switch result {
        case .success:
            if let data = data {
                do {
                    let genericModel = try JSONDecoder().decode(decodingType, from: data)
                    completion(.success(genericModel))
                }
                catch {
                    completion(Result.failure(.jsonParsingFailure))
                }
            } else {
                completion(Result.failure(.invalidData))
            }
        case .failure(let error):
            completion(Result.failure(error))
        }
    }
    
    func handleNetworkResponse(_ data: Data?, _ response: HTTPURLResponse, error: Error?) -> Result<Bool, APIError> {
        switch response.statusCode {
        case 200...299: return .success(true)
        case 400...499: return .failure(APIError.clientError(response.statusCode, error, data))
        case 500...599: return .failure(APIError.serverError(response.statusCode, error, data))
        default:
            return .failure(APIError.requestFailed(error))
        }
    }
}
