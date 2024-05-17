//
//  MovieResultsViewController.swift
//  DaffyTypeaheadProject
//

import UIKit

/// View controller for the movie results screen.
class MovieResultsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = MovieListView(frame: view.bounds)
        if let view = self.view as? MovieListView {
            let vm = MovieResultsViewModel()
            vm.parentViewController = self
            view.configureView(viewModel: vm)
        }
    }
}
