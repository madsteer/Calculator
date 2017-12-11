//
//  SaveSearchTweetTableViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 12/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SaveSearchTweetTableViewController: TweetTableViewController {

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func tryToSet(title searchText: String?) {
        super.tryToSet(title: searchText)
        if let searchText = searchText {
            let _ = updateDatabase(with: searchText)
        }
    }
    
    private func updateDatabase(with searchText: String) {
        container?.performBackgroundTask { [weak self] context in
            let _ = try? SavedSearch.findOrCreateSavedSearch(matching: searchText, in: context)
            try? context.save()
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let searchCount = try? context.count(for: SavedSearch.fetchRequest()) {
                    print("\(searchCount) saved searches")
                }
            }
        }
    }
}
