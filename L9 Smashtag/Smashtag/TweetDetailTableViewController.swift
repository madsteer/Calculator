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
//                mentionSections = initMensionSections(from: tweet)
                tableView.reloadData()
            }
        }
    }
    
    private var rowHeights: [Int:CGFloat] = [:]
    
    private var mentionSections: [MentionSection]?
    
    private struct MentionSection {
        var type: String
        var mentions: [MentionItem]
    }
    
    private enum MentionItem {
        case keyword(String)
        case image(URL, Double)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tweet?.media.count ?? 0
        case 1:
            return tweet?.hashtags.count ?? 0
        case 2:
            return tweet?.urls.count ?? 0
        default: break
        }
        
        return tweet?.userMentions.count ?? 0
    }
    
    private func initMensionSections(from tweet:Twitter.Tweet)-> [MentionSection]{
        var mentionSections = [MentionSection]()
        
        if  tweet.media.count > 0 {
            mentionSections.append(MentionSection(type: "Images",
                                                  mentions: tweet.media.map{ MentionItem.image($0.url, $0.aspectRatio)}))
        }
        if tweet.urls.count > 0 {
            mentionSections.append(MentionSection(type: "URLs",
                                                  mentions: tweet.urls.map{ MentionItem.keyword($0.keyword)}))
        }
        if tweet.hashtags.count > 0 {
            mentionSections.append(MentionSection(type: "Hashtags",
                                                  mentions: tweet.hashtags.map{ MentionItem.keyword($0.keyword)}))
        }
        var userItems = [MentionItem]()
        
        //------- Extra Credit 1 -------------
        // userItems += [MentionItem.keyword("@" + tweet.user.screenName )]
        //------------------------------------------------
        
        if tweet.userMentions.count > 0 {
            userItems += tweet.userMentions.map { MentionItem.keyword($0.keyword) }
        }
        if userItems.count > 0 {
            mentionSections.append(MentionSection(type: "Users", mentions: userItems))
        }
        
        return mentionSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = "User"
        
        switch indexPath.section {
        case 0:
            cellIdentifier = "Image"
        case 1:
            cellIdentifier = "Hashtag"
        case 2:
            cellIdentifier = "Url"
        default:
            break;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let imageCell = cell as? MentionImageTableViewCell, let item = tweet?.media[indexPath.row] {
            DispatchQueue.global(qos: .userInitiated).async {
                if let urlContents = try? Data(contentsOf: item.url) {
                    DispatchQueue.main.async {
                        imageCell.urlContents = urlContents
                        if let image = UIImage(data: urlContents) {
                            tableView.beginUpdates()
                            self.rowHeights[indexPath.row] = self.view.frame.width * (image.size.height / image.size.width)
                            tableView.endUpdates()
                        }
                    }
                }
            }
            
        } else if let hashtagCell = cell as? MentionHashtagTableViewCell, let item = tweet?.hashtags[indexPath.row] {
            hashtagCell.hashtag = item.keyword
            
        } else if let urlCell = cell as? MentionUrlTableViewCell, let item = tweet?.urls[indexPath.row] {
            urlCell.url = item.keyword
            
        } else if let userCell = cell as? MentionUserTableViewCell, let item = tweet?.userMentions[indexPath.row] {
            userCell.user = item.keyword            
        }
        
        return cell
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
        switch section {
        case 0:
            return determineSection(header: "Image", for: self.tableView(tableView, numberOfRowsInSection: section))
        case 1:
            return determineSection(header: "Hashtag", for: self.tableView(tableView, numberOfRowsInSection: section))
        case 2:
            return determineSection(header: "URL", for: self.tableView(tableView, numberOfRowsInSection: section))
        default:
            return determineSection(header: "User", for: self.tableView(tableView, numberOfRowsInSection: section))
        }
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
