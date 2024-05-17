//
//  MovieDataProvider.swift
//  DaffyTypeaheadProject
//

import Foundation

/// Movie data provider, responsible for setting up and kicking off requests to the API.
protocol MovieDataProviderProtocol {
    func loadMoviesWithSearch(searchText: String, page: Int, handler: @escaping (_ response: MovieResults?, _ error: Error?) -> Void)
    func loadMovieDetails(movieId: Int, handler: @escaping (_ response: MovieDetails?, _ error: Error?) -> Void)
    func downloadImageFrom(link: String, handler: ((_ data: Data?) -> Void)?)
}

final class MovieDataProvider: MovieDataProviderProtocol {
    func loadMoviesWithSearch(searchText: String, page: Int, handler: @escaping (_ response: MovieResults?, _ error: Error?) -> Void) {
        let endPoint = MovieAPI(path: "/search/movie", queryParam: "query=\(searchText)&page=\(page)")
        DaffyURLSession.sharedSession.sendRequest(endPoint, for: MovieResults.self) { result in
            switch result{
            case .success(let data):
                handler(data, nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }

    func loadMovieDetails(movieId: Int, handler: @escaping (_ response: MovieDetails?, _ error: Error?) -> Void) {
        let endPoint = MovieAPI(path: "/movie/\(movieId)")
        DaffyURLSession.sharedSession.sendRequest(endPoint, for: MovieDetails.self) { result in
            switch result{
            case .success(let data):
                handler(data, nil)
            case .failure(let error):
                handler(nil, error)
            }
        }
    }

    func downloadImageFrom(link: String, handler: ((_ data: Data?) -> Void)? = nil) {
        let endPoint = MovieAPI(path: "/t/p/w500\(link)")
        endPoint.requestType = .image
        DaffyURLSession.sharedSession.sendRequest(route: endPoint) { result in
            guard let handler = handler else {
                return
            }
            switch result{
            case let .success(data):
                handler(data)
            case .failure(let error):
                handler(nil)
            }
        }
    }
}
