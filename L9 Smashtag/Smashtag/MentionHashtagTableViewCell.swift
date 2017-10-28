//
//  MentionHashtagTableViewCell.swift
//  Smashtag
//
//  Created by Cory Steers on 10/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class MentionHashtagTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetHashtag: UILabel!
    
    var hashtag: String? { didSet { updateUI() } }
    
    private func updateUI() {
        if let hashtag = hashtag {
            tweetHashtag.text = hashtag
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
