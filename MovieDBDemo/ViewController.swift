//
//  ViewController.swift
//  MovieDBDemo
//
//  Created by Abdul Shamim on 7/13/18.
//  Copyright © 2018 Abdul Shamim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serverCall()
    }

    func serverCall() {
        let apiKey = "99c18e1c69dfb00bde386112c0080835"
        NetworkingClass(path: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)",
            method: .get)
            .config(activityIndicatorEnable: false)
            .connectServerWithoutImage(delay: 0){(_ response: Any?, data: Data?, error: Error?) in
                
                print("\(String(describing: response))")
                guard let data = data else {
                    return
                }
                let welcome = try? JSONDecoder().decode(Movies.self, from: data)
                print(welcome)
        }
        
    }
}

