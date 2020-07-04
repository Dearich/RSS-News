//
//  ExtentionTableDataSource.swift
//  RSS-News
//
//  Created by Азизбек on 05.07.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation
import UIKit

extension FeedTableViewController: UITableViewDataSource, UITableViewDelegate {
// MARK: - Table view data source

         func numberOfSections(in tableView: UITableView) -> Int {
            if isSorted {
               return sortedByCategoryObj.count
            }
            return 1
            
        }

         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            if isSorted {
                if sortedByCategoryObj[section].isExpanded {
                    return 0
                }
                return sortedByCategoryObj[section].sectionObjects.count
            }
            return news.count
    }

         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let new: NewModel?
            switch isSorted {
            case true:
                new = sortedByCategoryObj[indexPath.section].sectionObjects[indexPath.row]
            default:
                new = news[indexPath.row]
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            guard let newUnwraped = new else { return UITableViewCell() }
            cell.textLabel?.text = newUnwraped.title
            cell.detailTextLabel?.text = newUnwraped.date
            return cell
        }

         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "showNew", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }

         func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if isSorted{
                let subView = UIView()
                subView.backgroundColor = UIColor.systemBackground

                let headerView:UIView = {
                    let view = UIView()
                    view.backgroundColor = UIColor.systemGray5
                    view.layer.masksToBounds = true
                    view.layer.cornerRadius = 10
                    return view
                }()

                let label:UILabel = {
                    let label: UILabel = UILabel()
                    label.textColor = UIColor.label
                    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                    label.text = sortedByCategoryObj[section].sectionName
                    label.sizeToFit()
                    return label
                }()

                let button: UIButton = {
                    let button = UIButton(type: .system)
                    button.backgroundColor = .clear
                    if !sortedByCategoryObj[section].isExpanded {
                        button.setTitle("Скрыть", for: .normal)
                    } else {
                        button.setTitle("Показать", for: .normal)
                    }
                    button.tag = section
                    button.addTarget(self, action: #selector(handleHeaderAction), for: .touchUpInside)
                    return button
                }()

                subView.addSubview(headerView)

                headerView.addConstraintsWithFormat(format: "V:|-3-[v0]-3-|", views: headerView)
                headerView.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: headerView)

                headerView.addSubview(label)
                label.addConstraintsWithFormat(format: "V:|[v0]|", views: label)

                headerView.addSubview(button)
                button.superview?.bringSubviewToFront(button)
                button.addConstraintsWithFormat(format: "V:|[v0]|", views: button)
                button.addConstraintsWithFormat(format: "H:|-10-[v0][v1(80)]-|", views: label,button)

                return subView
            }
            return nil
        }

    @objc func handleHeaderAction( button: UIButton) {
        print("sectionTap")
        let section = button.tag //определние секции с помощью тега кнопки
        var indexPaths = [IndexPath]()

        let  isExpanded = sortedByCategoryObj[section].isExpanded
        sortedByCategoryObj[section].isExpanded = !isExpanded //меняем значение на противоположное

//        guard let tableView = self.tableView else { return }
        
        for row in sortedByCategoryObj[section].sectionObjects.indices {
            let indexPath = IndexPath(row: row, section: section )
            indexPaths.append(indexPath)
        }

        if !isExpanded {
            print(indexPaths)
            tableView.deleteRows(at: indexPaths, with: .fade)
            button.setTitle("Показать", for: .normal)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
            button.setTitle("Скрыть", for: .normal)
        }
    }

     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSorted {
            return 61.0
        }
        return 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showNew" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? NewViewController else { return }
                if isSorted {
                     destinationVC.new = sortedByCategoryObj[indexPath.section].sectionObjects[indexPath.row]
                } else {
                    destinationVC.new = news[indexPath.row]
                }
               
            }
        }
    }
}
