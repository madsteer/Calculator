//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

private extension NSMutableAttributedString {
    func setMensionsColor(_ mensions: [Twitter.Mention], color: UIColor) {
        for mension in mensions {
            addAttribute(NSForegroundColorAttributeName, value: color,
                         range: mension.nsrange)
        }
    }
}

class TweetTableViewCell: UITableViewCell {
    // outlets to the UI components in our Custom UITableViewCell
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    // public API of this UITableViewCell subclass
    // each row in the table has its own instance of this class
    // and each instance will have its own tweet to show
    // as set by this var
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    // whenever our public API tweet is set
    // we just update our outlets using this method
    private func updateUI() {
        tweetTextLabel?.attributedText = setTextLabel(tweet)
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async {
                        self.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tweetProfileImageView?.image = nil
                    }
                }
            }
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    private func setTextLabel(_ tweet: Twitter.Tweet?) -> NSMutableAttributedString {
        guard let tweet = tweet else {return NSMutableAttributedString(string: "")}
        var tweetText:String = tweet.text
        for _ in tweet.media {tweetText += " 📷"}
        
        let attributedText = NSMutableAttributedString(string: tweetText)
        
        attributedText.setMensionsColor(tweet.hashtags, color: .red)
        attributedText.setMensionsColor(tweet.urls, color: .blue)
        attributedText.setMensionsColor(tweet.userMentions, color: .orange)
        
        return attributedText
    }
}

// this helped on lldb printing issue: https://forums.developer.apple.com/thread/84400#251131
