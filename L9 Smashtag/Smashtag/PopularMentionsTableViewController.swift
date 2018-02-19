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
        if let context = container?.viewContext, mention != nil {
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                    key: "type",
                    ascending: true
                ), NSSortDescriptor(
                    key: "count",
                    ascending: false
                ),NSSortDescriptor(
                    key: "keyword",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            request.predicate = NSPredicate(
                format:"count > 1 AND searchTerm = %@", mention!)
            
            fetchedResultsController = NSFetchedResultsController<Mention>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "type", cacheName: nil)
            try? fetchedResultsController?.performFetch()
            fetchedResultsController?.delegate = self
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let frc = fetchedResultsController {
            return frc.sections!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Popular Mentions Cell", for: indexPath)
        
        if let fetchedMention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = fetchedMention.keyword
            cell.detailTextLabel?.text = "\(fetchedMention.count) tweet\((fetchedMention.count == 1) ? " don't want to display this" : "s" ) "
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionInfo = fetchedResultsController?.sections?[section] {
            return sectionInfo.name
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ToMainTweetTableView" {
                if let ttvc = segue.destination as? OldSearchTweetTableViewController,
                    let cell = sender as? UITableViewCell,
                    var text = cell.textLabel?.text {
                    if text.hasPrefix("@") { text += " OR from:" + text }
                    ttvc.searchText = text
                }
            }
        }
    }
}
