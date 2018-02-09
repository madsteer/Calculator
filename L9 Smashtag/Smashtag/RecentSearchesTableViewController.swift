//
//  RecentTweetTableViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 12/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class RecentSearchesTableViewController: FetchedResultsTableViewController {

    private var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    
    private var fetchedResultsController: NSFetchedResultsController<SavedSearch>?
    
    private var searchCount: Int? { didSet { tableView.reloadData() } }
    
    private func updateUI() {
        if let context = container?.viewContext /*, savedSearches != nil */ {
            let request: NSFetchRequest<SavedSearch> = SavedSearch.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController<SavedSearch>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchCount = nil
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let context = container?.viewContext, searchCount == nil {
            context.perform {
                if let count = try? context.count(for: SavedSearch.fetchRequest()) {
                    DispatchQueue.main.async { [weak self] in
                        self?.searchCount = count
                    }
                }
            }
        }
        return searchCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search Term Cell", for: indexPath)
        
        if let savedSearch = fetchedResultsController?.object(at: indexPath),
            let searchCell = cell as? SearchTermTableViewCell {
            searchCell.term = savedSearch.text
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            let cell = sender as? SearchTermTableViewCell {
            switch identifier {
            case "Show Tweets From Saved Search":
                if let seguedToMvc = segue.destination as? OldSearchTweetTableViewController,
                    let searchTerm = cell.term {
                    // do stuff
                    seguedToMvc.searchText = searchTerm
                }
            case "Show Most Popular Mentions":
                if let seguedToMvc = segue.destination as? PopularMentionsTableViewController {
//                    seguedToMvc.mention = cell.textLabel?.text
                    seguedToMvc.mention = cell.term
                    seguedToMvc.title = (cell.term ?? "") + ": Popularity"
                }                
            default:
                break
            }
        }
    }
}
