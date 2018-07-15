//
//  Constants.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.shared.delegate

struct ListType {
    static let popular = "Popular Movies"
    static let topRated = "Top Rated Movies"
}


struct API {
    static let key = "99c18e1c69dfb00bde386112c0080835"
    static let baseUrl = "https://api.themoviedb.org/3/"
    static let imageBaseUrl = "http://image.tmdb.org/t/p/w500"
    
    struct Path {
        static let popular = baseUrl + "movie/popular?api_key=\(key)"
        static let topRated = baseUrl + "movie/top_rated?api_key=\(key)"
        static let search =  baseUrl + "search/movie?api_key=\(key)"
    }
}

enum MoviesType: Int{
    case popular = 0
    case topRated = 1
}
