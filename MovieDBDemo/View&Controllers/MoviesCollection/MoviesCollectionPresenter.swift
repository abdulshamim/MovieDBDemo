//
//  MoviesCollectionPresenter.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import Foundation

struct API {
    static let key = "99c18e1c69dfb00bde386112c0080835"
    static let baseUrl = "https://api.themoviedb.org/3/"
    
    struct Path {
       static let popular = baseUrl + "movie/popular?api_key=\(key)"
       static let topRated = baseUrl + "movie/top-rated?api_key=\(key)"
    }
}

enum MoviesType: Int{
    case popular = 0
    case topRated = 1
}

class MoviesCollectionPresenter {
    
    var movies: Movies?
    var moviesType: MoviesType = .popular
    
    init() {
        
    }
    func getFullPath() -> String {
        switch moviesType {
        case .popular:
            return  API.Path.popular
        case .topRated:
            return  API.Path.popular
        }
    }
    
    func getMovies(callBack : @escaping (_ result: Movies?, _ isSuccess: Bool) -> Void) {
        let path = getFullPath()
        print(path)
        NetworkingClass(path: path,
            method: .get)
            .config(activityIndicatorEnable: false)
            .connectServerWithoutImage(delay: 0){(_ response: Any?, data: Data?, error: Error?) in
                
                print("\(String(describing: response))")
                guard let data = data else {
                    callBack(nil , false)
                    return
                }
                
                do {
                    self.movies = try JSONDecoder().decode(Movies.self, from: data)
                    print(self.movies)
                    callBack(self.movies! , true)
                } catch {
                    callBack(nil , false)
                }
                
        }
        
    }
    
}
