//
//  RequestAPI.swift
//  NYTimes
//
//  Created by Eric Gregor on 2018-04-05.
//  Copyright © 2018 Eric Gregor. All rights reserved.
//

import UIKit

protocol NetworkerType {
    func requestData(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
}

enum RequestAPIError: Error {
    case badURL
    case requestError
    case invalidJSON
}

class RequestAPI {
    
    var networker: NetworkerType
    
    init(networker: NetworkerType) {
        self.networker = networker
    }
}

extension RequestAPI {
    
//    func getArticles(section: String, completionHandler: @escaping ([Article]?, Error?) -> Void) {
//        guard let url = buildURL(endpoint: section) else {
//            completionHandler(nil, RequestAPIError.badURL)
//            return
//        }
//
//        self.networker.requestData(with: url) { (data, urlRequest, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//
//            guard let data = data else { return }
//            var results: [Article] = []
//
//            do {
//                let articlesData = try JSONDecoder().decode(Results.self, from: data)
//                results = articlesData.results
//            } catch let error {
//                completionHandler(nil, error)
//                return
//            }
//
//            completionHandler(results, nil)
//        }
//    }

    func buildURL(endpoint: String) -> URL? {
        var urlString = "https://api.nytimes.com/svc/topstories/v2/"
        if endpoint.isEmpty == false {
            urlString.append(endpoint)
        } else {
            urlString.append("home")
        }
        urlString.append(".json?api-key=975bddbb05904c2785109f1a9346e9d7")
        let url = URL(string: urlString)
        return url
    }

    func getArticles(section: String, completionHandler: @escaping ([Article]?, Error?) -> Void) {
        guard let url = buildURL(endpoint: section) else {
            completionHandler(nil, RequestAPIError.badURL)
            return
        }

        self.networker.requestData(with: url) { (data, urlRequest, error) in
            var json: [String: Any] = [:]
            var result: [Article] = []
            do {
                json = try self.jsonObject(fromData: data, response: urlRequest, error: error)
                result = try self.stories(fromJSON: json)
            } catch let error {
                completionHandler(nil, error)
                return
            }

            completionHandler(result, nil)
        }
    }

    func stories(fromJSON json: [String: Any]) throws -> [Article] {
        guard let results = json["results"] as? [[String: Any]] else {
            throw RequestAPIError.invalidJSON
        }

        var articles: [Article] = []
        for result in results {
            guard let title = result["title"], let url = result["url"] else {
                throw RequestAPIError.invalidJSON
            }
            guard let multimedia = result["multimedia"] as? [[String: Any]] else {
                throw RequestAPIError.invalidJSON
            }

            var imageUrl = ""
            if multimedia.count > 0 {
                imageUrl = multimedia[4]["url"]! as! String
            }
            
            if imageUrl.count > 0 {
                let image: UIImage? = nil
                
                let article = Article(title: title as! String, url: url as! String, imageUrl: imageUrl, image: image)
                articles.append(article)
            }
        }

        return articles
    }

    func jsonObject(fromData data: Data?, response: URLResponse?, error: Error?) throws -> [String: Any] {
        if let error = error {
            throw error
        }
        guard let data = data else {
            throw RequestAPIError.requestError
        }

        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

        guard let results = jsonObject as? [String: Any] else {
            throw RequestAPIError.invalidJSON
        }

        return results
    }
 
    func getArticleImage(urlString: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completionHandler(nil, RequestAPIError.badURL)
            return
        }

        self.networker.requestData(with: url) { (data, urlRequest, error) in
            var image: UIImage? = nil

            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            if let data = data {
                image = UIImage(data: data)
            }
            
            completionHandler(image, nil)
        }
    }

}
