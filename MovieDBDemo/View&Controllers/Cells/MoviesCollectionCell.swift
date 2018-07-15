//
//  MoviesCollectionCell.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit


class MoviesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }

    func setUpData(result: Result?) {
        if let result = result {
            self.titleLabel.text = result.title  ?? ""
            let imagePath = API.imageBaseUrl + (result.posterPath ?? "")
            self.posterImage.contentMode = .scaleToFill
            self.posterImage.kf.setImage(with: URL(string: imagePath)!, placeholder: nil)
        }
    }
}
