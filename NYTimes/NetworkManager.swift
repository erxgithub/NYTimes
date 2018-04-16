//
//  NetworkManager.swift
//  NYTimes
//
//  Created by Eric Gregor on 2018-04-05.
//  Copyright © 2018 Eric Gregor. All rights reserved.
//

import Foundation

class NetworkManager: NetworkerType {
    
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = urlSession.dataTask(with: url, completionHandler: completionHandler)
        dataTask.resume()
    }
}
