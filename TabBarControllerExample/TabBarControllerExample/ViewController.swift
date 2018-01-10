//
//  ViewController.swift
//  TabBarControllerExample
//
//  Created by Cory Steers on 11/22/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    private var petitions = [[String: String]]()
    
    let common = CommonViewControllerCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        
        if let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? String(contentsOf: url) {
                    let json = JSON(parseJSON: data)
                    DispatchQueue.main.async {
                        if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                            self.petitions.append(CommonViewControllerCode.parse(json: json))
                            return
                        }
                    }
                }
            }
        }
        present(CommonViewControllerCode.showError(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition["title"]
        cell.detailTextLabel?.text = petition["body"]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

