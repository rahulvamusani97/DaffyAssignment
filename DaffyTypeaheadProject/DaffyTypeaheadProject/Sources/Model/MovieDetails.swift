//
//  MovieDetails.swift
//  DaffyTypeaheadProject
//
//  Created by Rahul on 16/05/24.
//

import Foundation

struct MovieDetails: Codable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String
    var runtime: Int?
    var status: String?
    var tagline: String?
    
    private enum Codingkeys: String, CodingKey {
        case adult
        case backdropPath = "backdropPath"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case runtime
        case status
        case tagline
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Codingkeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        id = try values.decode(Int.self, forKey: .id)
        originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        title = try values.decode(String.self, forKey: .title)
        runtime = try values.decodeIfPresent(Int.self, forKey: .runtime)
        tagline = try values.decodeIfPresent(String.self, forKey: .tagline)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
