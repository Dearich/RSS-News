//
//  XMLParserHelper.swift
//  RSS-News
//
//  Created by Азизбек on 04.07.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

class XmlParserManager: NSObject, XMLParserDelegate {

    var parser = XMLParser()
    var news:[NewModel] = []
    var title = String()
    var pubDate = String()
    var element = String()
    var discription = String()
    var img = String()
    var category = String()
    var allCategories = [String]()

    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }

    func startParse(_ url :URL) {
           news = []
           parser = XMLParser(contentsOf: url)!
           parser.delegate = self
           parser.shouldProcessNamespaces = false
           parser.shouldReportNamespacePrefixes = false
           parser.shouldResolveExternalEntities = false
           parser.parse()

    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        element = elementName as String

        if (element as String).isEqual("item") {
            title = String()
            pubDate = String()
            category = String()

        } else if (element as String).isEqual("yandex:full-text") {
            discription = String()

        }else if (element as NSString).isEqual(to: "enclosure") {
            if let urlString = attributeDict["url"] {
                img = urlString
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let isoDate = pubDate.components(separatedBy: ",")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss ZZZ"
            let date = dateFormatter.date(from:isoDate[1])!
            dateFormatter.dateFormat = "d MMMM HH:mm"
            dateFormatter.locale = .init(identifier: "RU")
            let rightDate = dateFormatter.string(from: date)

            let new = NewModel(title: title, date: rightDate, imageURL: img, discription: discription, category: category)
            news.append(new)
            allCategories.append(new.category)

        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.element == "title" {
                title += data
            }
            if self.element == "pubDate" {
                pubDate += data
            }
            if self.element == "yandex:full-text" {
                discription += data
            }
            
            if self.element == "category" {
                category += data
            }
        }
    }
}
