//
//  Movies.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

class MoviesManager {
    static let shared = MoviesManager()
    var selectedMovie: Result?
}

class Movies: Codable {
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results = [Result]()
    
    
    init(json: [String: Any]) {
        if let page = json["page"] as? Int {
            self.page = page
        }
        if let totalResults = json["total_results"] as? Int {
            self.totalResults = totalResults
        }
        
        if let totalPages = json["total_pages"] as? Int {
            self.totalPages = totalPages
        }
        
        if let results = json["results"] as? [[String: Any]] {
            for result in results {
                let object = Result(json: result)
                self.results.append(object)
            }
        }
    }
}

class Result: Codable {
    var voteCount: Int?
    var id: Int?
    var video: Bool?
    var voteAverage: Double?
    var title: String?
    var popularity: Double?
    var posterPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIDS = [Int]()
    var backdropPath: String?
    var adult: Bool?
    var overview: String?
    var releaseDate: String?
    
    init(json: [String: Any]) {
        if let voteCount = json["vote_count"] as? Int {
            self.voteCount = voteCount
        }
        
        if let id = json["id"] as? Int {
            self.id = id
        }
        
        if let video = json["video"] as? Bool {
            self.video = video
        }
        if let voteAverage = json["vote_average"] as? Double {
            self.voteAverage = voteAverage
        }
        
        if let title = json["title"] as? String {
            self.title = title
        }
        
        if let popularity = json["popularity"] as? Double {
            self.popularity = popularity
        }
        
        if let posterPath = json["poster_path"] as? String {
            self.posterPath = posterPath
        }
        
        if let originalLanguage = json["original_language"] as? String {
            self.originalLanguage = originalLanguage
        }
        
        if let originalTitle = json["original_title"] as? String {
            self.originalTitle = originalTitle
        }
        
        if let genreIDS = json["genre_ids"] as? [Int] {
            self.genreIDS = genreIDS
        }
        
        if let backdropPath = json["backdrop_path"] as? String {
            self.backdropPath = backdropPath
        }
        if let adult = json["adult"] as? Bool {
            self.adult = adult
        }
        
        if let overview = json["overview"] as? String {
            self.overview = overview
        }
        
        if let releaseDate = json["release_date"] as? String {
            self.releaseDate = releaseDate
        }
    }
    
    
}


