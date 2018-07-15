//
//  MoviesCollectionController.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/14/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit
import AVFoundation



class MoviesCollectionController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var settingsButtonContainerView: UIView!
    @IBOutlet weak var settingViewHeight: NSLayoutConstraint!
    
    var searchActive : Bool = false
    var isSettingOpened = false
    
    
    var presenter: MoviesCollectionPresenter?
    
    
    @IBOutlet weak var settingBarButton: UIBarButtonItem! {
        didSet {
            let icon = UIImage(named: "settings")
            let iconSize = CGRect(origin: CGPoint.zero, size: icon!.size)
            let iconButton = UIButton(frame: iconSize)
            iconButton.setBackgroundImage(icon, for: .normal)
            iconButton.addTarget(self, action: #selector(settingsView), for: .touchUpInside)
            settingBarButton.customView = iconButton
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MoviesCollectionPresenter(viewController: self)
        self.searchBar.delegate = self
        
        self.settingViewHeight.constant = 0
        self.settingsButtonContainerView.isHidden = true
        self.getPopularMovieList(UIButton())
        self.setUp()
    }
    
    @objc func settingsView() {
        if isSettingOpened {
            self.hideSettingView()
        } else {
            self.showSettingView()
        }
        
        settingBarButton.customView?.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi * 6/5))
        UIView.animate(withDuration: 1.0) {
            self.settingBarButton.customView?.transform = CGAffineTransform.identity
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        presenter?.setUpNavigationBar(vc: self)
    }
    

    @IBAction func getPopularMovieList(_ sender: UIButton) {
        self.collectionView.reloadData()
        self.presenter?.moviesType = .popular
        self.title = ListType.popular
        self.getMovies(page: (self.presenter?.popularMoviesPageCount) ?? 1)
    }
    
    @IBAction func getTopRatedMoviesList(_ sender: UIButton) {
        self.collectionView.reloadData()
        self.presenter?.moviesType = .topRated
        self.title = ListType.topRated
        self.getMovies(page: (self.presenter?.topRatedPageCount) ?? 1)
    }
    
    //Shoe setting View
    func showSettingView() {
        self.isSettingOpened = true
        UIView.animate(withDuration: 0.5, animations: {
            self.settingsButtonContainerView.isHidden = false
            self.settingViewHeight.constant = 45
             self.view.layoutIfNeeded()
        })
    }
    
    //Hide setting View
    func hideSettingView() {
        self.isSettingOpened = false
        UIView.animate(withDuration: 0.5, animations: {
            
            self.settingViewHeight.constant = 0
             self.view.layoutIfNeeded()
        }) { (success) in
            self.settingsButtonContainerView.isHidden = true
        }
    }
    
    
    //MARK :- Get Movies list from server
    func getMovies(page: Int) {
        if self.isSettingOpened == true {
            self.hideSettingView()
        }
        presenter?.getMovies(pageCount: page) {[weak self] (result: Movies?, isSuccess: Bool) in
            if isSuccess {
                DispatchQueue.main.async {
                     self?.collectionView.reloadData()
                }
            }
        }
    }

    // MARK: Register collection nib cell and setup UI
    func setUp() {
        searchBar.placeholder = "Search"
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView.register(UINib(nibName: "MoviesCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MoviesCollectionCell")
    }
  
}
// MARK: Collection Delegates
extension MoviesCollectionController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return presenter?.searchedMovies?.results.count ?? 0
        } else {
            switch self.presenter?.moviesType {
            case .popular?:
                return presenter?.popularMovies.count ?? 0
            case .topRated?:
                return presenter?.topRatedMovies.count ?? 0
            default:
                return presenter?.popularMovies.count ?? 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionCell", for: indexPath as IndexPath) as? MoviesCollectionCell else {
            fatalError("Constant.Message.cellNotFound")
        }
        if searchActive {
            cell.setUpData(result: (presenter?.searchedMovies?.results[indexPath.row])!)
        } else {
            switch self.presenter?.moviesType {
            case .popular?:
                cell.setUpData(result: (presenter?.popularMovies[indexPath.row]) ?? nil)
            case .topRated?:
                cell.setUpData(result: (presenter?.topRatedMovies[indexPath.row]) ?? nil)
            default:
                cell.setUpData(result: (presenter?.popularMovies[indexPath.row]) ?? nil)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailsController") as? MovieDetailsController
        if searchActive {
            vc?.movie = presenter?.searchedMovies?.results[indexPath.row]
        } else {
            switch self.presenter?.moviesType {
            case .popular?:
                 vc?.movie = presenter?.popularMovies[indexPath.row]
            case .topRated?:
                 vc?.movie = presenter?.topRatedMovies[indexPath.row]
            default:
                vc?.movie = presenter?.popularMovies[indexPath.row]
            }
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width - 14) / 2
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.minimumInteritemSpacing = 2
        flowLayout?.minimumLineSpacing = 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
       // print(lastRowIndex)
       // print(indexPath.row )
        if indexPath.row == lastRowIndex {
            
            if let page = presenter?.movies?.page, let totalPage = presenter?.movies?.totalPages {
                if page < totalPage {
                    switch self.presenter?.moviesType {
                    case .popular?:
                        self.getMovies(page: (self.presenter?.popularMoviesPageCount)! + 1)
                    case .topRated?:
                        self.getMovies(page: (self.presenter?.topRatedPageCount)! + 1)
                    default:
                        break
                    }
                    
                }
            }
        }
    }
    
}

 // MARK: UISearchbar
extension MoviesCollectionController: UISearchBarDelegate {
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       print(searchText)
        
        if searchText.isEmpty {
            searchActive = false
        } else {
            
            if searchText.count > 2 {
                self.searchMovie(string: searchText)
                searchActive = true
            }
        }
        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchActive = false
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
//        searchActive = false
//        collectionView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchActive = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
       
        if searchBar.text?.count != 0 {
            self.searchMovie(string: searchBar.text!)
            searchActive = true
        } else {
             searchActive = false
        }
        collectionView.reloadData()
    }
    
    func searchMovie(string: String) {
        self.hideSettingView()
        
        presenter?.searchMovie(query: string) {[weak self] (result: Movies?, isSuccess: Bool) in
            if isSuccess {
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

}
