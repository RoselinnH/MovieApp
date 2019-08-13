//
//  MoviesViewModel.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit.UIImage

final class MovieListMaker {
    
    private var movieList = [Movie]()
    private var searchMovieList = [Movie]()
    var defaultImage = UIImage(named: "ImageNotFound")
    
    func buildMovieList(movies: Movies, movieImage: [MoviePoster], isSearch: Bool, isTyping: Bool)-> [Movie] {
        if isTyping {
            self.movieList.removeAll()
            searchMovieList.removeAll()
        }
        movies.results?.forEach({ (result) in
            let rating = createFiveStarRating(vote: result.voteAverage ?? 0.0)
            let imageToUse = movieImage.first(where: { $0.imagePath == result.posterPath })
            let movie = Movie(title: result.title ?? "Movie Title",
                              poster: imageToUse?.image ?? defaultImage!,
                              fiveStarRating: rating,
                              overView: result.overview ?? "Details")
            isSearch ? self.searchMovieList.append(movie) : self.movieList.append(movie)
        })
        
        return isSearch ? searchMovieList : self.movieList
    }
    
    func createFiveStarRating(vote: Double) -> Int {
        let rating = (vote * 5) / 10
        return Int(rating)
    }
}


