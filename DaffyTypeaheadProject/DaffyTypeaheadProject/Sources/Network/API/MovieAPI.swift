//
//  MovieAPI.swift
//  DaffyTypeaheadProject
//

import Foundation

/// Protocol that designates properties relevant to API endpoints.
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var url: URL? { get }
    var method: HTTPMethod { get }
}

/// API details for the Movie Database.
class MovieAPI: Endpoint {
    static let apiKey = "b229fc85b40d58d13d1493c1e65dd5c2"
    
    var method: HTTPMethod {
        return httpMethod ?? .get
    }
    var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    var path: String {
        return apiPath ?? ""
    }
    var requestType = RequestType.movie
    
    var url: URL? {
        var contructedPath: String
        switch requestType {
        case .movie:
            contructedPath = self.baseURL + path + "?api_key=\(MovieAPI.apiKey)"
        case .image:
            contructedPath = "https://image.tmdb.org" + path
        }
        if let queryParam = query {
            contructedPath += "&" + queryParam
        }
        return URL(string: contructedPath)
    }
    var apiPath: String?
    var query: String?
    var httpMethod: HTTPMethod?

    init(path: String, queryParam: String? = nil, method: HTTPMethod = .get) {
        self.apiPath = path
        self.query = queryParam
        self.httpMethod = method
    }
    
    enum RequestType {
        case movie
        case image
    }
}
