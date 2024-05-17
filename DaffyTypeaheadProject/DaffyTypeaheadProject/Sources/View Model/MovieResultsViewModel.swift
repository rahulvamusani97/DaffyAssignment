//
//  MovieResultsViewModel.swift
//  DaffyTypeaheadProject
//

import Foundation
import UIKit

/// View model for the movie results screen.
final class MovieResultsViewModel {
    private let movieDataProvider: MovieDataProviderProtocol
    
    var currentPage: Int = 1
    var totalPages: Int = 1
    var searchText: String = "" {
        didSet {
            currentPage = 1
            movieResults = []
        }
    }
    var movieResults: [Movie]? = [Movie]()
    var parentViewController: UIViewController?
    
    init(movieDataProvider: MovieDataProviderProtocol = MovieDataProvider()) {
        self.movieDataProvider = movieDataProvider
    }
    
    func loadMoviesWithSearch(handler: @escaping ((_ success: Bool) -> Void)) {
        self.movieDataProvider.loadMoviesWithSearch(searchText: searchText, page: currentPage) { [weak self] response, error in
            guard let data = response, let results = data.results, let totalPages = data.totalPages, results.count > 0, error == nil else {
                self?.movieResults = []
                handler(false)
                return
            }
            var filtered = results.filter { $0.overview?.count ?? 0 > 0 }
            filtered.sort { $0.title.lowercased() < $1.title.lowercased() }
            self?.movieResults?.append(contentsOf: filtered)
            self?.totalPages = totalPages
            handler(true)
        }
    }
    
    func downloadImageFrom(link: String?, handler: ((_ data: Data?) -> Void)? = nil)  {
        guard let path = link else { return }
        movieDataProvider.downloadImageFrom(link: path, handler: handler)
    }
    
    func loadMovieDetails(movieId: Int, handler: @escaping ((_ details: MovieDetails?) -> Void)) {
        self.movieDataProvider.loadMovieDetails(movieId: movieId, handler: { response, error in
            guard let data = response, error == nil else {
                handler(nil)
                return
            }
            handler(data)
        })
    }
    
    func getLanguage(originalLanguage: String?) -> String? {
        switch originalLanguage {
        case "en":
            return "English"
        case "fr":
            return "French"
        case "ja":
            return "Japanese"
        default:
            return nil
        }
    }
}
