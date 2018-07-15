//
//  MoviesCollectionController.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit
import AVFoundation

let window = UIApplication.shared.keyWindow?.rootViewController

class MoviesCollectionController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var presenter = MoviesCollectionPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.prefersLargeTitles = true
        self.collectionViewSetUp()
        
        self.getPopularMovies()
    }
    
    @IBAction func openSettings(_ sender: UIBarButtonItem) {
        let saveMenuItem = UIMenuItem(title: "Popular Movies", action: #selector(getPopularMovies))
        let deleteMenuItem = UIMenuItem(title: "Top Rated Movies", action: #selector(getTopRatedMovies))
        UIMenuController.shared.menuItems = [saveMenuItem, deleteMenuItem]
        
        // Tell the menu controller the first responder's frame and its super view
        UIMenuController.shared.setTargetRect(CGRect(x: 100, y: 200, width: 200, height: 50), in: window!.view.superview!)
        
        // Animate the menu onto view
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    @objc func getPopularMovies() {
        print("Popular")
        self.presenter.moviesType = .popular
        self.getMovies()
    }
    
    @objc func getTopRatedMovies() {
        print("Top rated")
        self.presenter.moviesType = .topRated
        self.getMovies()
    }
    
    
    //MARK :- Get Movies list from server
    func getMovies() {
        presenter.getMovies {[weak self] (result: Movies?, isSuccess: Bool) in
            if isSuccess {
                DispatchQueue.main.async {
                    print( self?.presenter.movies?.results)
                     self?.collectionView.reloadData()
                }
            }
        }
    }

    
    fileprivate func collectionViewSetUp() {
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        collectionView.register(UINib(nibName: "MoviesCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MoviesCollectionCell")
    }
  
}
// MARK :- Collection Delegates
extension MoviesCollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.movies?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionCell", for: indexPath as IndexPath) as? MoviesCollectionCell else {
            fatalError("Constant.Message.cellNotFound")
        }
       
        cell.setUpData(result: (presenter.movies?.results[indexPath.row])!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width - 14) / 2
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.minimumInteritemSpacing = 2
        flowLayout?.minimumLineSpacing = 2
        return CGSize(width: width, height: width)
    }
    
}

