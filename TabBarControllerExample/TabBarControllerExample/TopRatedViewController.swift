//
//  TopRatedViewController.swift
//  TabBarControllerExample
//
//  Created by Cory Steers on 11/30/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

class TopRatedViewController: UITableViewController {

    private var topRatedPetitions = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"

        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    DispatchQueue.main.async {
                        if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        self.topRatedPetitions.append(CommonViewControllerCode.parse(json: json))
                            return
                        }
                    }
                }
            }
        }
        present(CommonViewControllerCode.showError(), animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return topRatedPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedCell", for: indexPath)
        let petition = topRatedPetitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = topRatedPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
