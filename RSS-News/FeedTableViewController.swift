//
//  FeedTableViewController.swift
//  RSS-News
//
//  Created by Азизбек on 04.07.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import Foundation

struct SortedByCategories {
    var sectionName: String
    var sectionObjects: [NewModel]
    var isExpanded:Bool
}

class FeedTableViewController: UITableViewController {

    var news:[NewModel] = []
    let searchController = UISearchController(searchResultsController: nil)
    var dictionatyByCategoryKey = [String:[NewModel]]()
    var sortedByCategoryObj = [SortedByCategories]()
    var isSorted:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadData()

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sort"), style: .plain, target: self, action: #selector(sortTapped))
    }
    @objc func sortTapped() {
        isSorted = !isSorted
        tableView.reloadData()
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        print("refresh")
        loadData()
        sender.endRefreshing()
        
    }

    func loadData()  {
        sortedByCategoryObj.removeAll()
        news.removeAll()
        guard let url = URL(string: "http://www.vesti.ru/vesti.rss") else { return }
        let myParser : XmlParserManager = XmlParserManager().initWithURL(url) as! XmlParserManager
        news = myParser.news
        print("loadData")

        for item in myParser.allCategories {
             dictionatyByCategoryKey[item] = [NewModel]()
        }

        for new in news {
            dictionatyByCategoryKey[new.category]?.append(new)
        }
        let sortedDic = dictionatyByCategoryKey.sorted(by: { $0.0 < $1.0 })
        for (key, value) in sortedDic {
            sortedByCategoryObj.append(SortedByCategories(sectionName: key, sectionObjects: value, isExpanded: true))
        }
        tableView.reloadData()

    }
}

extension FeedTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

