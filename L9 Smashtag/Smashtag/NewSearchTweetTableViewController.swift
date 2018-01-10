//
//  NewSearchTweetTableViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 12/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class NewSearchTweetTableViewController: TweetTableViewController {

    // set ourself to be the UITextFieldDelegate
    // so that we can get textFieldShouldReturn sent to us
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    // when the return (i.e. Search) button is pressed in the keyboard
    // we go off to search for the text in the searchTextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    override func didSet(_ searchText: String?) {
        super.didSet(searchText)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let identifier = segue.identifier {
            switch identifier {
            case "tweetDetailSegue":
                finishPeparing(for: segue, sender)
            default: break
            }
        }
    }
}
