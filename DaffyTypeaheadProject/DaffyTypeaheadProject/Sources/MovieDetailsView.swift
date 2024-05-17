//
//  MovieDetailsView.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 16/05/24.
//

import Foundation
import UIKit

final class MovieDetailsView: UIView {
    private var root = UIView()

    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let movieImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.layer.cornerRadius = 8.0
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = true
        return imgView
    }()

    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Book", size: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "Avenir-Book", size: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tagLineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let runtimeLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.textColor = .lightGray
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
    
    func configureView(details: MovieDetails, viewModel: MovieResultsViewModel?) {

        layout()
        guard let vm = viewModel else { return }
        vm.downloadImageFrom(link: details.posterPath) { data in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                self?.movieImageView.image = UIImage(data: data)
            }
        }
        movieImageView.image = UIImage(named: "placeholder")
        movieTitleLabel.text = details.title
        descriptionLabel.text = details.overview
        if let language = vm.getLanguage(originalLanguage: details.originalLanguage) {
            languageLabel.text = "Language: \(language)"
        }
        if let date = details.releaseDate {
            releaseLabel.text = "Release Date: \(date)"
        }
        if let staus = details.status {
            statusLabel.text = "Status: \(staus)"
        }
        if let runtime = details.runtime {
            runtimeLbl.text = "Run Time: \(runtime) Minutes"
        }
    }
    
    func layout() {
        backgroundColor = .white
        addSubview(root)
        root.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(movieImageView)
        verticalStackView.addArrangedSubview(movieTitleLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(languageLabel)
        verticalStackView.addArrangedSubview(releaseLabel)
        verticalStackView.addArrangedSubview(statusLabel)
        verticalStackView.addArrangedSubview(tagLineLabel)
        verticalStackView.addArrangedSubview(runtimeLbl)
        let margins = layoutMarginsGuide
        let constraints: [NSLayoutConstraint] = [movieImageView.widthAnchor.constraint(equalToConstant: frame.size.width), movieImageView.heightAnchor.constraint(equalToConstant: 300),verticalStackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor), verticalStackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor), verticalStackView.topAnchor.constraint(equalTo: margins.topAnchor), verticalStackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
}
