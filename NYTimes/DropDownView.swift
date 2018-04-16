//
//  DropDownView.swift
//  NYTimes
//
//  Created by Eric Gregor on 2018-04-06.
//  Copyright © 2018 Eric Gregor. All rights reserved.
//

import UIKit

protocol DropDownProtocol {
    func dropDownPressed(string: String)
}

protocol ArticleProtocol {
    func refreshArticles(section: String)
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    //var dropDownOptions = [String]()
    var dropDownOptions = [MenuItem]()
    
    var tableView = UITableView()
    var delegate: DropDownProtocol!
    var articleDelegate: ArticleProtocol!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //tableView.backgroundColor = UIColor.white
        //self.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = dropDownOptions[indexPath.row].title
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row].title)
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.articleDelegate.refreshArticles(section: dropDownOptions[indexPath.row].section)
    }
}
