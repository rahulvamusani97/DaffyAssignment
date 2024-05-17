//
//  MovieResultsTableViewCell.swift
//  DaffyTypeaheadProject
//

import UIKit

/// Custom cell class for the movie table view.
class MovieTableViewCell: UITableViewCell {
    static let cellReuseIdentifier = "MovieTableViewCell"
    
    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        return stack
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Book", size: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Book", size: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Medium", size: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 8.0
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = true
        return imgView
    }()
    
    //MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    private func layout() {
        imageStackView.addArrangedSubview(movieImageView)
        imageStackView.addArrangedSubview(languageLabel)
        titleStackView.addArrangedSubview(movieTitleLabel)
        titleStackView.addArrangedSubview(descriptionLabel)
        titleStackView.addArrangedSubview(releaseLabel)
        contentView.addSubview(imageStackView)
        contentView.addSubview(titleStackView)
        addConstraints()
        languageLabel.isHidden = true
        releaseLabel.isHidden = true
    }
    
    private func addConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        let constaints: [NSLayoutConstraint] = [imageStackView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor), imageStackView.topAnchor.constraint(equalTo: marginGuide.topAnchor), movieImageView.widthAnchor.constraint(equalToConstant: 120), movieImageView.heightAnchor.constraint(equalToConstant: 100), titleStackView.leadingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: 8), titleStackView.topAnchor.constraint(equalTo: marginGuide.topAnchor), titleStackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor), titleStackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)]
        NSLayoutConstraint.activate(constaints)
    }
    
    func configureCell(movie: Movie, viewModel: MovieResultsViewModel) {
        let isoverViewMissing = movie.overview?.count == 0
        movieTitleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        movieImageView.image = UIImage(named: "placeholder")
        languageLabel.isHidden = true
        releaseLabel.isHidden = true
        if let language = viewModel.getLanguage(originalLanguage: movie.originalLanguage) {
            languageLabel.text = "Language: \(language)"
            languageLabel.isHidden = false
        }
        if let date = movie.releaseDate, !isoverViewMissing {
            releaseLabel.text = "Release Date: \(date)"
            releaseLabel.isHidden = false
        }
        viewModel.downloadImageFrom(link: movie.posterPath) { data in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                self?.movieImageView.image = UIImage(data: data)
                self?.movieImageView.contentMode = .scaleToFill
            }
        }
    }
    
}
