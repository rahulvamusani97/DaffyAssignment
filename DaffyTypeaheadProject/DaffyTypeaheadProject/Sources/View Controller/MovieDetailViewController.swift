//
//  MovieDetailViewController.swift
//  DaffyTypeaheadProject
//

import UIKit

/// View controller for the movie detail screen.
class MovieDetailViewController: UIViewController {
    var details: MovieDetails?
    var viewModel: MovieResultsViewModel?
    
    init(details: MovieDetails?, viewModel: MovieResultsViewModel?) {
        super.init(nibName: nil, bundle: nil)
        self.details = details
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.details?.title
        self.view = MovieDetailsView(frame: view.bounds)
        if let view = self.view as? MovieDetailsView, let data = self.details {
            view.configureView(details: data, viewModel: self.viewModel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
