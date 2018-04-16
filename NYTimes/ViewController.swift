//
//  ViewController.swift
//  NYTimes
//
//  Created by Eric Gregor on 2018-04-05.
//  Copyright © 2018 Eric Gregor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ArticleProtocol {

    var networkManager: NetworkerType = NetworkManager()
    var button = DropDownButton()

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!

    var articles: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
        logoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        button = DropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //button.setTitle("Colors", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 30.0).isActive = true

        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //button.dropDownView.dropDownOptions = ["Blue", "Green", "Magenta", "White", "Black", "Pink"]
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 30.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        var menuItems: [MenuItem] = []
        
        menuItems.append(MenuItem(title: "Home", section: "home"))
        menuItems.append(MenuItem(title: "Arts", section: "arts"))
        menuItems.append(MenuItem(title: "Automobiles", section: "automobiles"))
        menuItems.append(MenuItem(title: "Books", section: "books"))
        menuItems.append(MenuItem(title: "Business", section: "business"))
        menuItems.append(MenuItem(title: "Fashion", section: "fashion"))
        menuItems.append(MenuItem(title: "Food", section: "food"))
        menuItems.append(MenuItem(title: "Health", section: "health"))
        menuItems.append(MenuItem(title: "Insider", section: "insider"))
        menuItems.append(MenuItem(title: "Magazine", section: "magazine"))
        menuItems.append(MenuItem(title: "Movies", section: "movies"))
        menuItems.append(MenuItem(title: "National", section: "national"))
        menuItems.append(MenuItem(title: "NY/Region", section: "nyregion"))
        menuItems.append(MenuItem(title: "Obituaries", section: "obituaries"))
        menuItems.append(MenuItem(title: "Opinion", section: "opinion"))
        menuItems.append(MenuItem(title: "Politics", section: "politics"))
        menuItems.append(MenuItem(title: "Real Estate", section: "realestate"))
        menuItems.append(MenuItem(title: "Science", section: "science"))
        menuItems.append(MenuItem(title: "Sports", section: "sports"))
        menuItems.append(MenuItem(title: "Sunday Review", section: "sundayreview"))
        menuItems.append(MenuItem(title: "Technology", section: "technology"))
        menuItems.append(MenuItem(title: "Theater", section: "theater"))
        menuItems.append(MenuItem(title: "T Magazine", section: "tmagazine"))
        menuItems.append(MenuItem(title: "Travel", section: "travel"))
        menuItems.append(MenuItem(title: "Upshot", section: "upshot"))
        menuItems.append(MenuItem(title: "World", section: "world"))
        
        button.dropDownView.dropDownOptions = menuItems
        button.setTitle(menuItems[0].title, for: .normal)
        button.dropDownView.articleDelegate = self
        
        refreshArticles(section: menuItems[0].section)

//        let urlString = "https://api.nytimes.com/svc/topstories/v2/arts.json?api-key=975bddbb05904c2785109f1a9346e9d7"
//
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//
//            guard let data = data else { return }
//            //Implement JSON decoding and parsing
//            do {
//                //Decode retrived data with JSONDecoder and assing type of Article object
//                let articlesData = try JSONDecoder().decode(Results.self, from: data)
//
//                //Get back to the main queue
//                DispatchQueue.main.async {
//                    print(articlesData)
//                    self.articles = articlesData.results
//                    //self.collectionView?.reloadData()
//                }
//
//            } catch let jsonError {
//                print(jsonError)
//            }
//        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func refreshArticles(section: String) {
        let requestAPI = RequestAPI(networker: networkManager)
        requestAPI.getArticles(section: section) { (articles, error) in
            if let error = error {
                print("Error: \(error)")
            }
            guard let articles = articles else {
                print("Error getting articles")
                return
            }
            
            DispatchQueue.main.async {
                //print(articles)
                self.articles = articles
                self.collectionView?.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCell", for: indexPath) as! ArticleViewCell
        
        let article = articles![indexPath.row]
        
        if article.image == nil {
            cell.imageView.image = nil

            let urlString = article.imageUrl
 
            let requestAPI = RequestAPI(networker: networkManager)
            requestAPI.getArticleImage(urlString: urlString) { (image, error) in
                if let error = error {
                    print("Error: \(error)")
                }
                guard let image = image else {
                    print("Error getting article image")
                    return
                }
                
                DispatchQueue.main.async {
                    self.articles![indexPath.row].image = image
                    cell.imageView.image = image
                }
            }
        } else {
            cell.imageView.image = article.image
        }
        
        cell.titleLabel.text = article.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width - 10) / 2, height: 150)
    }
    
}
