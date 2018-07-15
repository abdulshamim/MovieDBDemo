//
//  MovieDetailsPrrsenter.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import Foundation

class MovieDetailsPresenter: NSObject {
    
    weak var movieDetailsController: MovieDetailsController?
    

    init(viewController: MovieDetailsController) {
        super.init()
        self.movieDetailsController = viewController
    }
    
    func setView(vc: MovieDetailsController) {
        if #available(iOS 11.0, *) {
            vc.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
        }
        vc.title = MoviesManager.shared.selectedMovie?.originalTitle
        movieDetailsController?.tableView.dataSource = movieDetailsController
        movieDetailsController?.tableView.separatorStyle = .none
        movieDetailsController?.tableView.estimatedRowHeight = 550
    }
}
