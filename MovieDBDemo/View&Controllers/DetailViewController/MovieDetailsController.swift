//
//  MovieDetailsController.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit

class MovieDetailsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var movieDetailsPresenter: MovieDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailsPresenter = MovieDetailsPresenter(viewController: self)
        movieDetailsPresenter?.setView(vc: self)
    }
}

extension MovieDetailsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.movieDetailCell, for: indexPath) as? MovieDetailCell else {
            fatalError("cell not found")
        }
        cell.setUpData(movie: MoviesManager.shared.selectedMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

}
