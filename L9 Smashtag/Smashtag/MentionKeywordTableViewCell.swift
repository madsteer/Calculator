//
//  MentionKeywordTableViewCell.swift
//  Smashtag
//
//  Created by Cory Steers on 10/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class MentionKeywordTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetKeyword: UILabel!
    
    
    var keyword: String? { didSet { updateUI() } }
    
    private func updateUI() {
        if let keyword = keyword {
            tweetKeyword.text = keyword
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
