//
//  FeedTableViewController.swift
//  RSS-News
//
//  Created by Азизбек on 04.07.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import Foundation

class FeedTableViewController: UITableViewController {

    var news:[NewModel] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadData()
        setUpSearchBar()
    }
    @objc func refresh(_ sender: UIRefreshControl) {
       // Code to refresh table view
        print("refresh")
        loadData()
        sender.endRefreshing()
    }

    func loadData()  {
        guard let url = URL(string: "http://www.vesti.ru/vesti.rss") else { return }
        let myParser : XmlParserManager = XmlParserManager().initWithURL(url) as! XmlParserManager
        news = myParser.news
        tableView.reloadData()
        print("loadData")
    }

    func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите категорию"
        searchController.searchBar.becomeFirstResponder()
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let new = news[indexPath.row]

        cell.textLabel?.text = new.title
        cell.detailTextLabel?.text = new.date

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showNew", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
//            self.loadMore()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showNew" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                 guard let destinationVC = segue.destination as? NewViewController else { return }
                destinationVC.new = news[indexPath.row]
            }
        }
    }
}
extension FeedTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

