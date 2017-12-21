//
//  OldSearchTweetTableViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 12/21/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class OldSearchTweetTableViewController: TweetTableViewController {

    @IBOutlet weak var searchTextLabel: UILabel!
    
    override func didSet(_ searchText: String?) {
        super.didSet(searchText)
        if let searchText = searchText {
            searchTextLabel.text = searchText
        }
    }

    
}
