//
//  MentionImageTableViewCell.swift
//  Smashtag
//
//  Created by Cory Steers on 10/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class MentionImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImage: UIImageView!
    
    var urlContents: Data? { didSet{ updateUI() } }
    
    private func updateUI() {
        if let urlContents = urlContents {
            tweetImage.image = UIImage(data: urlContents)
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
