//
//  MovieListView.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 16/05/24.
//

import Foundation
import UIKit

final class MovieListView: UIView {
    
    private var root = UIView()
    private var viewModel: MovieResultsViewModel?
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.backgroundColor = .white
        return stack
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .default
        bar.placeholder = "Search Movies"
        bar.autocapitalizationType = .none
        bar.setShowsCancelButton(true, animated: true)
        bar.delegate = self
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorColor = .gray
        view.separatorStyle = .singleLine
        view.estimatedRowHeight = 100
        view.rowHeight = UITableView.automaticDimension
        view.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.cellReuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Type in the Search Bar above"
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        root.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(viewModel: MovieResultsViewModel) {
        self.viewModel = viewModel
        layout()
    }
    
    func layout() {
        backgroundColor = .white
        addSubview(root)
        root.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(searchBar)
        verticalStackView.addArrangedSubview(tableView)
        verticalStackView.addArrangedSubview(errorLabel)
        self.tableView.isHidden = true
        let margins = layoutMarginsGuide
        let constraints: [NSLayoutConstraint] = [verticalStackView.leadingAnchor.constraint(equalTo: root.leadingAnchor), verticalStackView.trailingAnchor.constraint(equalTo: root.trailingAnchor), verticalStackView.topAnchor.constraint(equalTo: margins.topAnchor), verticalStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
        
    private func getMoviesBasedOnSearch() {
        guard let viewModel = viewModel else { return }
        viewModel.loadMoviesWithSearch(handler: { [weak self] success in
            self?.handleMoviesResponse(success: success)
        })
    }

    private func reloadTableView() {
        if self.tableView.delegate == nil {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
        self.tableView.reloadData()
    }
    
    private func handleMoviesResponse(success: Bool) {
        DispatchQueue.main.async { [weak self] in
            if success {
                self?.reloadTableView()
                self?.tableView.isHidden = false
                self?.errorLabel.isHidden = true
            } else {
                self?.tableView.isHidden = true
                self?.errorLabel.isHidden = false
                self?.errorLabel.text = "No Results for your search criteria. Refine your search and try again !!"
            }
        }
    }
        
    @objc private func getSearchResults() {
        getMoviesBasedOnSearch()
    }
    
    private func navigateToDetails(details: MovieDetails?) {
        guard let vm = viewModel else { return }
        DispatchQueue.main.async {
            if let result = details {
                let movieDetailsVC = MovieDetailViewController(details: result, viewModel: vm)
                vm.parentViewController?.navigationController?.pushViewController(movieDetailsVC, animated: true)
            } else {
                showAlert(title: "No Details Available")
            }
        }
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource

extension MovieListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.movieResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellReuseIdentifier, for: indexPath) as? MovieTableViewCell, let vm = viewModel, let data = vm.movieResults, data.indices.contains(indexPath.row) {
           let movie = data[indexPath.row]
            cell.selectionStyle = .none
            cell.configureCell(movie: movie, viewModel: vm)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vm = viewModel, let movie = vm.movieResults?[safe: indexPath.row] {
            vm.loadMovieDetails(movieId: movie.id) { [weak self] details in
                self?.navigateToDetails(details: details)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let vm = viewModel, let results = vm.movieResults else { return }
        if indexPath.row == results.count - 1, vm.currentPage < vm.totalPages {
            vm.currentPage += 1
            getMoviesBasedOnSearch()
        }
    }
}

// MARK: UISearchBarDelegate

extension MovieListView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchText = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(getSearchResults),
                                               object: nil)
        perform(#selector(getSearchResults),
                with: nil, afterDelay: 0.75)
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.resignFirstResponder()
    }
}
