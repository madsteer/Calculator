//
//  SearchTermTableViewCell.swift
//  Smashtag
//
//  Created by Cory Steers on 12/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class SearchTermTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTerm: UILabel!
    
    var term: String? { didSet { updateUI() } }
    
    private func updateUI() {
        if let term = term {
            searchTerm.text = term
        }
    }
}
