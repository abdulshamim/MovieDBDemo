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
    
    var movie: Result?
    
    var movieDetailsPresenter: MovieDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailsPresenter = MovieDetailsPresenter(viewController: self)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = movie?.originalTitle
        movieDetailsPresenter?.setTableView()
    }


}

extension MovieDetailsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailCell", for: indexPath) as? MovieDetailCell else {
            fatalError("cell not found")
        }
        cell.setUpData(movie: self.movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

}
