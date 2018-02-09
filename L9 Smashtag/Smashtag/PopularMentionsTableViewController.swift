//
//  PopularMentionsTableViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 1/11/18.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class PopularMentionsTableViewController: FetchedResultsTableViewController {
    private var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }

    private var fetchedResultsController: NSFetchedResultsController<Mention>?
    
    var mention: String? { didSet{ updateUI() } }

    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                    key: "count",
                    ascending: false
                ),NSSortDescriptor(
                    key: "keyword",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            request.predicate = NSPredicate(
                format:"count > 1 AND searchTerm = %@", mention!)
            
            fetchedResultsController = NSFetchedResultsController<Mention>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "count", cacheName: nil)
            
            try? fetchedResultsController?.performFetch()
            fetchedResultsController?.delegate = self
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Popular Mentions Cell", for: indexPath)
        if let mention = fetchedResultsController?.object(at: indexPath){
            cell.textLabel?.text = mention.keyword
            let mentionsCount = mention.count
            cell.detailTextLabel?.text = "\(mentionsCount) tweet\((mentionsCount == 1) ? " don't want to display this" : "s")"
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            if identifier == "ToMainTweetTableView"{
                if let ttvc = segue.destination as? OldSearchTweetTableViewController,
                    let cell = sender as? UITableViewCell,
                    var text = cell.textLabel?.text {
                    if text.hasPrefix("@") {text += " OR from:" + text}
                    ttvc.searchText = text
                }
                
            }
        }
    }
}
