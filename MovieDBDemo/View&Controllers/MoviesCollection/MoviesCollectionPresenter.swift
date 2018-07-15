//
//  MoviesCollectionPresenter.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import Foundation




class MoviesCollectionPresenter: NSObject {

    var popularMoviesPageCount: Int? = 1
    var popularMovies = [Result]()
    
    var topRatedPageCount: Int? = 1
    var topRatedMovies = [Result]()
    
    var searchedMovies: Movies?
    var movies: Movies?
    var moviesType: MoviesType = .popular
    
    weak var moviesCollectionController: MoviesCollectionController?
    
    override init() {
        
    }
    
    init(viewController: MoviesCollectionController) {
        super.init()
    }
    
    //SetUp Naviation controller
    func setUpNavigationBar(vc: MoviesCollectionController) {
        vc.title = ListType.popular
        vc.navigationController?.navigationBar.prefersLargeTitles = true
        vc.navigationController?.navigationBar.barTintColor = UIColor.red
        vc.navigationController?.navigationBar.tintColor = .white
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        vc.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
   
    
    func getFullPath() -> String {
        switch moviesType {
        case .popular:
            return  API.Path.popular
        case .topRated:
            return  API.Path.topRated
        }
    }
    
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
    
    
    func searchMovie(query: String, callBack : @escaping (_ result: Movies?, _ isSuccess: Bool) -> Void) {
        let searchTerm =  "&query=\(query)"
        let path = API.Path.search + searchTerm
        print(path)
        //
        DispatchQueue.main.async {
            CLProgressHUD.present(animated: true)
        }
        
        NetworkingClass(path: path,
                        method: .get)
            .config(activityIndicatorEnable: false)
            .connectServerWithoutImage(delay: 0){(_ response: Any?, data: Data?, error: Error?) in
                DispatchQueue.main.async {
                    CLProgressHUD.dismiss(animated: true)
                }
                print("\(String(describing: response))")
                guard let response = response as? [String: Any] else {
                    callBack(nil , false)
                    return
                }
                
                self.searchedMovies = Movies(json: response)
                print(self.movies)
                callBack(self.movies! , true)
                
        }
    }
}
