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

    var savedSearches: [String]? { didSet { updateUI() } }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.estimatedRowHeight = tableView.rowHeight
//        tableView.rowHeight = UITableViewAutomaticDimension
//    }

    private lazy var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    
    private var fetchedResultsController: NSFetchedResultsController<SavedSearch>?
    
    private func updateUI() {
        if let context = container?.viewContext, savedSearches != nil {
            let request: NSFetchRequest<SavedSearch> = SavedSearch.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
//            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            fetchedResultsController = NSFetchedResultsController<SavedSearch>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSearches?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search Term Cell", for: indexPath)
        
        if let savedSearches = savedSearches {
            let savedSearch = savedSearches[indexPath.row]
            
            if let searchCell = cell as? SearchTermTableViewCell {
                searchCell.term = savedSearch
            }
        }
        
        return cell
    }

}
