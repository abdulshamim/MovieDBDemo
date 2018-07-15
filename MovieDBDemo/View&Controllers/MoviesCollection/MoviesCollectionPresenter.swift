//
//  MoviesCollectionPresenter.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit

class MoviesCollectionPresenter: NSObject {

    var popularMoviesPageCount: Int? = 1
    var popularMovies = [Result]()
    
    var topRatedPageCount: Int? = 1
    var topRatedMovies = [Result]()
    
    var searchedMovies: Movies?
    var movies: Movies?
    var moviesType: MoviesType = .popular
    
    var isSettingOpened = false
    
    
    weak var moviesCollectionController: MoviesCollectionController?
    
    override init() {
    }
    
    init(viewController: MoviesCollectionController) {
        super.init()
    }
    
    // MARK : Set controller tilte
    func setTitle(vc: MoviesCollectionController) {
        switch moviesType {
        case .popular:
            vc.title = ListType.popular
        case .topRated:
            vc.title = ListType.topRated
        }
    }
    
    // MARK : SetUp Naviation controller
    func setUpNavigationBar(vc: MoviesCollectionController) {
        vc.title = ListType.popular
        if #available(iOS 11.0, *) {
            vc.navigationController?.navigationBar.prefersLargeTitles = true
            vc.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        } else {
            // Fallback on earlier versions
        }
        
        vc.navigationController?.navigationBar.barTintColor = UIColor.red
        vc.navigationController?.navigationBar.tintColor = .white
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
       
    }
    
    func setCollectionBackgroundView(_ frame: CGRect) -> UIView {
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let label = UILabel(frame: CGRect(x: 0, y: frame.height/2 - 100, width: frame.width, height: 60))
        label.text = "No movies found"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        backgroundView.addSubview(label)
        return backgroundView
    }

   
    // MARK : Get Api path for popular and top rated
    func getFullPath() -> String {
        switch moviesType {
        case .popular:
            return  API.Path.popular
        case .topRated:
            return  API.Path.topRated
        }
    }
    
    // MARK : Get movies from tmdb server
    func getMovies(pageCount: Int, callBack : @escaping (_ result: Movies?, _ isSuccess: Bool) -> Void) {
        let path = getFullPath() + "&language=en-US&page=\(pageCount)"
        print(path)
        
        DispatchQueue.main.async {
           UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
       
        NetworkingClass(path: path,
            method: .get)
            .config(activityIndicatorEnable: false)
            .connectServerWithoutImage(delay: 0){(_ response: Any?, data: Data?, error: Error?) in
                
                print("\(String(describing: response))")
                guard let response = response as? [String: Any] else {
                    callBack(nil , false)
                    return
                }
                
                self.movies = Movies(json: response)
                for movie in self.movies?.results ?? [] {
                    switch self.moviesType {
                    case .popular:
                        self.popularMoviesPageCount = self.movies?.page
                        self.popularMovies.append(movie)
                    case .topRated:
                        self.topRatedMovies.append(movie)
                        self.topRatedPageCount = self.movies?.page
                    }
                    
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                callBack(self.movies! , true)
        }
        
    }
    
    
    // MARK : Search movies on tmdb server
    func searchMovie(query: String, callBack : @escaping (_ result: Movies?, _ isSuccess: Bool) -> Void) {
        let searchTerm =  "&query=\(query)"
        let path = API.Path.search + searchTerm
        print(path)
        //
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        NetworkingClass(path: path,
                        method: .get)
            .config(activityIndicatorEnable: false)
            .connectServerWithoutImage(delay: 0){(_ response: Any?, data: Data?, error: Error?) in
               
                print("\(String(describing: response))")
                guard let response = response as? [String: Any] else {
                    callBack(nil , false)
                    return
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                self.searchedMovies = Movies(json: response)
                print(self.movies ?? "Movie not found")
                callBack(self.movies! , true)
        }
    }
}
