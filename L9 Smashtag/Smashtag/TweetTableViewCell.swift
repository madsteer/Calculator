//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

extension UILabel {
    func colorTweet() {
        guard let splitText = self.text?.components(separatedBy: " ") else {
            return
        }
        
        var attributedStrings: [NSMutableAttributedString] = []
        for text in splitText {
            var color = UIColor.black
            if text.hasPrefix("#") {
                color = .red
            } else if text.hasPrefix("http") {
                color = .blue
            }
            let yourAttributes = [NSForegroundColorAttributeName: color]
            attributedStrings.append(NSMutableAttributedString(string: text, attributes: yourAttributes))
            
        }
        
        let attributedSpace = NSMutableAttributedString(string: " ", attributes: [NSForegroundColorAttributeName: UIColor.black])
        let combinedAttributedString = NSMutableAttributedString()
        
        for index in 0...attributedStrings.count-1 {
            combinedAttributedString.append(attributedStrings[index])
            if index < attributedStrings.count - 1 {
                combinedAttributedString.append(attributedSpace)
            }
        }

        self.attributedText = combinedAttributedString
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
        tweetTextLabel?.text = tweet?.text
        tweetTextLabel?.colorTweet()
//        tweetTextLabel = findTextToBeautify(input: tweetTextLabel)
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            // FIXME: blocks main thread
            if let imageData = try? Data(contentsOf: profileImageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        } else {
            tweetProfileImageView?.image = nil
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
    
    
//    private func findTextToBeautify(input: UILabel) -> UILabel {
//        let result = input
//        if let inputText = input.text {
//            let urls = inputText.findURLs()
//            for url in urls {
//                result.colorTweet(text: inputText, coloredText: url, color: .blue)
//            }
//            
////            let hashtags = inputText.extractRegex(using: "(#[A-za-z0-9]*)")
//            let hashtags = inputText.extractRegex(using: "#\\w+")
//            for hashtag in hashtags {
//                result.colorTweet(text: inputText, coloredText: hashtag, color: .red)
//            }
//        }
//        return result
//    }
}
// "Sara Van Belle: In search of a global health community of “kick-ass” women https://t.co/OLMifLXBXg #Stanford"

// this helped on lldb printing issue: https://forums.developer.apple.com/thread/84400#251131
