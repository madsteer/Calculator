//
//  CommonViewControllerCode.swift
//  TabBarControllerExample
//
//  Created by Cory Steers on 11/30/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

struct CommonViewControllerCode {

    static func parse(json: JSON) -> [String: String] {
        var result: [String: String] = [:]
        for element in json["results"].arrayValue {
            let title = element["title"].stringValue
            let body = element["body"].stringValue
            let sigs = element["signatureCount"].stringValue
            result = ["title": title, "body": body, "sigs": sigs]
//            topRatedPetitions.append(obj)
        }
//        tableView.reloadData()
        return result
    }
    
    static func showError() -> UIAlertController {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        return ac
//        present(ac, animated: true)
    }
    
}
