//
//  MovieList.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-08.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import UIKit.UIImage

struct MoviePoster {
    var image: UIImage
    var imagePath: String
}

final class MovieList {
    
    private var movieListMaker = MovieListMaker()
    private(set) var list: [Movie]?
    private var imageList = [MoviePoster]()
    private var closureReturnedValue: Movies?
    private let imageUrlString = "http://image.tmdb.org/t/p/w185/"
    private let getMoviesURL = "https://api.themoviedb.org/3/discover/movie?api_key=1dc0db694147e61de0a29b550866eb64&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="
    private let searchMoviesURL = "https://api.themoviedb.org/3/search/movie?api_key=1dc0db694147e61de0a29b550866eb64&language=en-US&include_adult=false&"

    
    func setList(pageNumber page: Int, query: String?, isTyping: Bool, then: @escaping () -> Void) {
        let webServiceHandler = WebServiceHandler()
        var api = ""
        if query != nil {
            api = self.searchMoviesURL + query!
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let group = DispatchGroup()
            group.enter()
            webServiceHandler.getMovies(pageNumber: page, apiTouse: query != nil ? api : self.getMoviesURL) { [weak self] (content, error) in
                guard let self = self else {return}
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let contentData = content else { return }
                self.closureReturnedValue = contentData
                group.leave()
            }
            group.wait()
            self.closureReturnedValue?.results?.forEach({ (result) in
                guard let path = result.posterPath else {return}
                group.enter()
                Alamofire.request(self.imageUrlString + path, method: .get).responseImage { response in
                    guard let image = response.result.value else { return }
                    let moviePoster = MoviePoster(image: image, imagePath: path)
                    self.imageList.append(moviePoster)
                    group.leave()
                }
            })
            group.wait()
            let isSearch = query != nil ? true : false
            guard self.closureReturnedValue != nil  else {return}
            self.list = self.movieListMaker.buildMovieList(movies: self.closureReturnedValue!, movieImage: self.imageList, isSearch: isSearch, isTyping: isTyping)
            then()
        }
    }
}



