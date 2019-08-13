//
//  Movies.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct Movie {
    var title: String
    var poster: UIImage
    var fiveStarRating: Int
    var overView: String
}

struct Movies: Decodable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Results]?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }
    
    struct Results: Decodable {
        let voteCount: Int?
        let id: Int?
        let video: Bool?
        let voteAverage: Double?
        let title: String?
        let popularity: Double?
        let posterPath: String?
        let originalLanguage: String?
        let originalTitle: String?
        let genreIds: [Int]?
        let backdropPath: String?
        let adult: Bool?
        let overview: String?
        let releaseDate: String?
        
        enum CodingKeys: String, CodingKey {
            case voteCount = "vote_count"
            case id
            case video
            case voteAverage = "vote_average"
            case title
            case popularity
            case posterPath = "poster_path"
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case genreIds = "genre_ids"
            case backdropPath = "backdrop_path"
            case adult
            case overview
            case releaseDate
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            video = try values.decodeIfPresent(Bool.self, forKey: .video)
            voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)
            title = try values.decodeIfPresent(String.self, forKey: .title)
            popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
            posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
            originalLanguage = try values.decodeIfPresent(String.self, forKey: .originalLanguage)
            originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
            genreIds = try values.decodeIfPresent([Int].self, forKey: .genreIds)
            backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
            adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
            overview = try values.decodeIfPresent(String.self, forKey: .overview)
            releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        }
        
    }
}
