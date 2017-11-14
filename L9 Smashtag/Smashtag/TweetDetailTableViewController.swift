//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 10/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

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
        static let ImageSegue = "Show Image"
        static let WebSegue = "Show URL"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //------- Extra Credit 1 -------------
        // userItems += [MentionItem.keyword("@" + tweet.user.screenName )]
        //------------------------------------------------
        
        section = MentionSection(type: MentionTypeKey.User.rawValue, mentions: userItems)
        if tweet.userMentions.count > 0 {
            userItems += tweet.userMentions.map { MentionItem.keyword($0.keyword) }
            section.mentions = userItems
        }
        mentionSections[MentionTypeKey.User] = section

        return mentionSections
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.KeywordSegue:
                if let cell = sender as? MentionKeywordTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let seguedToMvc = segue.destination as? TweetTableViewController {
                    
                    let mentionSectionKey = MentionTypeKey.fore[indexPath.section]
                    switch mentionSectionKey {
                    case .Hashtag, .User:
                        if let mention = mentionSections[mentionSectionKey]?.mentions[indexPath.row] {
                            if case MentionItem.keyword(let keyword) = mention {
                                seguedToMvc.searchText = keyword
                            }
                        }
                    default: break
                    }
                }
            default: break
            }
        }
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
