//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 10/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import SafariServices

class TweetDetailTableViewController: UITableViewController {

    var tweet: Twitter.Tweet? {
        didSet {
            if let tweet = tweet {
                title = tweet.user.screenName
                mentionSections = initMensionSections(from: tweet)
                tableView.reloadData()
            }
        }
    }
    
    private var rowHeights: [Int:CGFloat] = [:]
    
    private var mentionSections: [MentionTypeKey:MentionSection] = [:]
    
    private struct MentionSection {
        var type: String
        var mentions: [MentionItem]
    }
    
    private enum MentionItem {
        case keyword(String)
        case image(URL, Double)
    }
    
    private enum MentionTypeKey : String {
        case Image = "Image"
        case Hashtag = "Hashtag"
        case URL = "URL"
        case User = "User"
        
        static let fore /* yes it's misspelled, but "for" is a keyword */ = [Image, Hashtag, URL, User]
    }
    
    private struct Storyboard {
        static let KeywordCell = "Keyword"
        static let ImageCell = "Image"
        
        static let KeywordSegue = "newKeywordSearchSegue"
        static let ImageSegue = "showImageSegue"
//        static let WebSegue = "showURLSegue"
    }

    @objc private func tempReturn() {
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReturnHome()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func initMensionSections(from tweet:Twitter.Tweet)-> [MentionTypeKey:MentionSection]{
        var mentionSections = [MentionTypeKey:MentionSection]()
        
        var section: MentionSection = MentionSection(type: MentionTypeKey.Image.rawValue, mentions: [MentionItem]())
        if  tweet.media.count > 0 {
            section.mentions = tweet.media.map{ MentionItem.image($0.url, $0.aspectRatio)}
        }
        mentionSections[MentionTypeKey.Image] = section

        section = MentionSection(type: MentionTypeKey.Hashtag.rawValue, mentions: [MentionItem]())
        if tweet.hashtags.count > 0 {
            section.mentions = tweet.hashtags.map{ MentionItem.keyword($0.keyword)}
        }
        mentionSections[MentionTypeKey.Hashtag] = section

        section = MentionSection(type: MentionTypeKey.URL.rawValue, mentions: [MentionItem]())
        if tweet.urls.count > 0 {
            section.mentions = tweet.urls.map{ MentionItem.keyword($0.keyword)}
        }
        mentionSections[MentionTypeKey.URL] = section

        var userItems = [MentionItem]()
        
        userItems += [MentionItem.keyword("@" + tweet.user.screenName )]
        
        section = MentionSection(type: MentionTypeKey.User.rawValue, mentions: userItems)
        if tweet.userMentions.count > 0 {
            userItems += tweet.userMentions.map { MentionItem.keyword($0.keyword) }
            section.mentions = userItems
        }
        mentionSections[MentionTypeKey.User] = section

        return mentionSections
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionSections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mentionSections[MentionTypeKey.fore[section]]?.mentions.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = (mentionSections[MentionTypeKey.fore[indexPath.section]]?.mentions[indexPath.row])!
        
        switch mention {
        case .keyword(let keyword):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.KeywordCell, for: indexPath)
            cell.textLabel?.text = keyword
            return cell
        case .image(let url, let aspectRatio):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ImageCell, for: indexPath)
            if let imageCell = cell as? MentionImageTableViewCell {
                imageCell.spinner.startAnimating()
                DispatchQueue.global(qos: .userInitiated).async {
                    if let urlContents = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            imageCell.urlContents = urlContents
                                tableView.beginUpdates()
                                self.rowHeights[indexPath.row] = self.view.frame.width * CGFloat(aspectRatio)
                                tableView.endUpdates()
                        }
                    }
                }
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: for URL rows only
        if mentionSections[MentionTypeKey.fore[indexPath.section]]?.type == "URL",
            let keyword = finishNewSearchKeywordSegue(indexPath),
            let url = URL(string: keyword) {
            
            var vc: SFSafariViewController
            
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                vc = SFSafariViewController(url: url, configuration: config)
            } else {
                vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            }
            
            present(vc, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if let height = rowHeights[indexPath.row] {
                return height
            } else {
                return UITableViewAutomaticDimension
            }
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    private func hasMultipleRows(_ tableview: UITableView, in section: Int) -> Bool {
        return tableView(tableview, numberOfRowsInSection: section) > 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return determineSection(header: MentionTypeKey.fore[section].rawValue, for: self.tableView(tableView, numberOfRowsInSection: section))
    }
    
    private func determineSection(header: String, for numberOfRows: Int) -> String? {
        switch numberOfRows {
        case 0:
            return nil
        case 1:
            return header
        default:
            return header + "s"
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.KeywordSegue,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            mentionSections[MentionTypeKey.fore[indexPath.section]]?.type == "URL" {
    
            // MARK to open with webkit in our app
            
//            performSegue(withIdentifier: Storyboard.WebSegue, sender: sender)
            
            // MARK: if we want to open in mobile Safari
            
//            if let keyword = finishNewSearchKeywordSegue(indexPath),
//                let url = URL(string: keyword) {
//
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: {
//                        (succes) in
//                        print("Opening \(keyword) was successful!")
//                    })
//                } else {
//                    print("Opening \(keyword) was \(UIApplication.shared.openURL(url))")
//                }
//            }
            
            return false // we don't segue for URL rows when using SFSafariViewController
            
        }
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.KeywordSegue:
                if let cell = sender as? MentionKeywordTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let seguedToMvc = segue.destination as? NewSearchTweetTableViewController {
                    
                    if let keyword = finishNewSearchKeywordSegue(indexPath) {
                        seguedToMvc.searchText = keyword
                    }
                }
                
                // case Storyboard.WebSegue:  // MARK: we don't segue for URLs when using SFSafariViewController
                
                // MARK: custom view controller with a UIWebView
                
//                if let cell = sender as? MentionKeywordTableViewCell,
//                    let indexPath = tableView.indexPath(for: cell),
//                    let seguedToMvc = segue.destination as? URLMentionViewController {
//
//                    if let keyword = finishNewSearchKeywordSegue(indexPath) {
//                        seguedToMvc.urlString = keyword
//                    }
//
//                }
                
                // MARK: use SFSafariViewController
                
//                let safariConfig = SFSafariViewController.Configuration()
//                safariConfig.entersReaderIfAvailable = true
//                let seguedToMvc = segue.destination as? SFSafariViewController
                
                
                
            case Storyboard.ImageSegue:
                if let cell = sender as? MentionImageTableViewCell,
                    let seguedToMvc = segue.destination as? ImageViewController {
                    seguedToMvc.imageView = cell.tweetImage
                }
                
            default: break
            }
        }
    }
    
    private func finishNewSearchKeywordSegue(_ indexPath: IndexPath) -> String? {
        let mentionSectionKey = MentionTypeKey.fore[indexPath.section]
        switch mentionSectionKey {
        case .Hashtag, .User, .URL:
            if let mention = mentionSections[mentionSectionKey]?.mentions[indexPath.row] {
                if case MentionItem.keyword(let keyword) = mention {
                    return enchanceUserSearchForPosted(by: keyword)
                }
            }
        default: break
        }
        return nil
    }
    
    private func enchanceUserSearchForPosted(by keyword: String) -> String {
        if let newKeyword = keyword.substring(after: "@") {
            return "\(keyword) OR from:\(newKeyword)"
        }
        return keyword
    }
}
