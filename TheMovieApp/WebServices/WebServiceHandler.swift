//
//  WebServiceHandler.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-07.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

enum WebService: Error {
    case malformedURL
    case invalidResponse

    case parsingFailure
}

final class WebServiceHandler{
    private let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=1dc0db694147e61de0a29b550866eb64&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="
    private let imageUrlString = "http://image.tmdb.org/t/p/w185/"
    let decoder = JSONDecoder()
    
    func getMovies(pageNumber: Int, apiTouse apiURL: String, then: @escaping (Movies?, Error?)-> Void){
        let movieURL = "\(apiURL)\(pageNumber)".folding(options: .diacriticInsensitive, locale: .current)
        guard let url = URL(string: movieURL) else {
            then(nil, WebService.malformedURL)
            return
        }
        Alamofire.request(url).responseJSON{  response in
            switch response.result {
            case .success:
                guard
                    let data = response.data,
                    let movies = try? self.decoder.decode(Movies.self, from: data)
                    else{
                        then(nil, WebService.parsingFailure)
                        return
                }
                then(movies, nil)
            case .failure(let error):
                print(error.localizedDescription)
                then(nil, error)
            }
        }
    }    
}


