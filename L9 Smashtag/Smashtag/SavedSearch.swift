//
//  SavedSearch.swift
//  Smashtag
//
//  Created by Cory Steers on 12/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class SavedSearch: NSManagedObject {
    class func findOrCreateSavedSearch(matching searchInfo: String, in context: NSManagedObjectContext) throws -> [SavedSearch] {
        let request: NSFetchRequest<SavedSearch> = SavedSearch.fetchRequest()
        request.predicate = NSPredicate(format: "search_string = %@", searchInfo)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
//                assert(matches.count == 1, "SavedSearch.findOrCreateSavedSearch -- database inconsistency")
                return matches
            }
        } catch {
            throw error
        }
        
        let savedSearch = SavedSearch(context: context)
        savedSearch.text = searchInfo
        savedSearch.created = Date() as NSDate
        
        var savedSearches: [SavedSearch] = []
        savedSearches.append(savedSearch)
        return savedSearches
    }
}
