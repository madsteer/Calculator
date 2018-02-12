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
    
    private var popularityCount: Int? { didSet { tableView.reloadData() } }

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
            
            fetchedResultsController = NSFetchedResultsController<Mention>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "type", cacheName: nil)
//            fetchedResultsController = NSFetchedResultsController<Mention>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

            try? fetchedResultsController?.performFetch()
            fetchedResultsController?.delegate = self
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        popularityCount = nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let context = container?.viewContext, popularityCount == nil {
            context.perform {
                if let count = try? context.count(for: Mention.fetchRequest()) {
                    DispatchQueue.main.async { [weak self] in
                        self?.popularityCount = count
                    }
                }
            }
        }
        return popularityCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Popular Mentions Cell", for: indexPath)
        if let sections = fetchedResultsController?.sections, indexPath.section < sections.count, indexPath.row < sections[indexPath.section].numberOfObjects {
            if let fetchedMention = fetchedResultsController?.object(at: indexPath) {
                cell.textLabel?.text = fetchedMention.keyword
                let mentionsCount = fetchedMention.count
                cell.detailTextLabel?.text = "\(mentionsCount) tweet\((mentionsCount == 1) ? " don't want to display this" : "s" ) "
            }
        }
        return cell
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
