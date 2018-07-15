//
//  URLSession.swift
//  CallbackDemo
//
//  Created by Abdul on 09/09/17.
//  Copyright © 2017 Abdul. All rights reserved.
//

import UIKit

public typealias CompletionHandler = (_ result: Any?, _ data: Data?, _ error: Error?) -> Void

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

class NetworkingClass {

    //static let share = NetworkingClass()
    
    private var urlString: String?
    private var method: HTTPMethod? = .get
    private var headers = [String: String]()
    private var urlRequest: URLRequest?
    private var session = URLSession()
    private let config = URLSessionConfiguration.default
    
    private var isNetworkActivityIndicatorEnable: Bool = false

    private var completeCallBack: CompletionHandler?



    init(path: String, method: HTTPMethod) {
        self.urlString = path
        self.method = method
        
        guard let urlString = URL(string: path) else {
            return
        }
        
        self.session = URLSession(configuration: config)
        urlRequest = URLRequest(url: urlString)
        urlRequest?.httpMethod = method.rawValue
    }
    
    @discardableResult
    func config(activityIndicatorEnable: Bool) -> NetworkingClass {
        DispatchQueue.main.async {
            self.isNetworkActivityIndicatorEnable = activityIndicatorEnable
        }
        return self
    }
    
    @discardableResult
    func headers(headers: [String: String]) -> NetworkingClass {
        self.headers = headers
        return self
    }
    
    // MARK :-  Make server call without Images
    func connectServerWithoutImage(delay: Double, completion: @escaping CompletionHandler) {
       self.completeCallBack = completion

       if delay == 0.0 {
           self.startRequest()
       } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.startRequest()
        })
       }
    }
    
    // MARK :-  Make server call with Images
    func connectServerWithImages(delay: Double, completion: @escaping CompletionHandler) {
        self.completeCallBack = completion

        if delay == 0.0 {
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            })
        }
    }

    
    
    // MARK :- Start server requesting
    func startRequest() {
        guard let urlRequest = urlRequest else {
            self.completeCallBack?(nil, nil, nil)
            return
        }
       
        UIApplication.shared.isNetworkActivityIndicatorVisible = self.isNetworkActivityIndicatorEnable
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            self.requestSucceededWith(response: data, error: error)
        })
        task.resume()
    }
    
    // MARK :- Response handling
    private func requestSucceededWith(response: Data?, error: Error?) {
        guard let responseData = response else {
            print("Error: did not receive data")
            self.completeCallBack?(nil, nil, error)
            return
        }
        do {
            guard let result = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                print("error trying to convert data to JSON")
                self.completeCallBack?(nil, nil, error)
                return
            }
            self.completeCallBack?(result, responseData, error)
        } catch {
            print("Some error occurred")
            self.completeCallBack?(nil, nil, nil)
        }
    }
}
