//
//  MovieDetailCell.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(movie: Result?) {
        if let movie = movie {
            self.movieTitleLabel.text = movie.title ?? ""
            self.ratingLabel.text = "\(String(describing: movie.voteAverage ?? 0))"
            self.releaseDateLabel.text = "Release Date: " + (movie.releaseDate ?? "")
            self.overviewLabel.text = movie.overview
            
            let imagePath = API.imageBaseUrl + (movie.posterPath ?? "")
            print(imagePath)
            self.posterImage.contentMode = .scaleToFill
            self.posterImage.kf.setImage(with: URL(string: imagePath)!, placeholder: nil)
//            self.posterImage.image = self.posterImage.image?.scaled(to: posterImage.frame.size, scalingMode: .aspectFill)
        }
    }
}
