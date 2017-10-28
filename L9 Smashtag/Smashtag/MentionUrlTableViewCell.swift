//
//  MentionUrlTableViewCell.swift
//  Smashtag
//
//  Created by Cory Steers on 10/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class MentionUrlTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetUrl: UILabel!
    
    var url: String? { didSet{ updateUI() } }
    
    private func updateUI() {
        if let url = url {
            tweetUrl.text = url
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
