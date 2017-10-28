//
//  MentionUserTableViewCell.swift
//  Smashtag
//
//  Created by Cory Steers on 10/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class MentionUserTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetUser: UILabel!
    
    var user: String? { didSet { updateUI() } }
    
    private func updateUI() {
        if let user = user {
            tweetUser.text = user
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
