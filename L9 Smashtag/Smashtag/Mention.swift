//
//  Mention.swift
//  Smashtag
//
//  Created by Cory Steers on 1/12/18.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class Mention: NSManagedObject {
    class func findOrCreateMention(with keyword: String, and type: String, using searchTerm: String, in context: NSManagedObjectContext) throws -> Mention {
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword LIKE[cd] %@ AND searchTerm =[cd] %@", keyword, searchTerm)
        
        let existingMentions = try context.fetch(request)
        if !existingMentions.isEmpty {
            assert (existingMentions.count == 1, "mention, findOrCreateMention -- database inconsistency")
            return existingMentions[0]
        } else {
            let mention = Mention(context: context)
            mention.count = 0
            mention.keyword = keyword
            mention.type = type
            mention.searchTerm = searchTerm
            return mention
        }
    }
    
    static func checkMention(for tweet: Tweet, with keyword: String, and type: String, using searchTerm: String, in context: NSManagedObjectContext) throws -> Mention
    {
        let mention = try findOrCreateMention(with: keyword, and: type, using: searchTerm, in: context)
        
        if let tweetsSet = mention.tweets as? Set<Tweet>, !tweetsSet.contains(tweet) {
            mention.addToTweets(tweet)
            mention.count =  Int64((mention.count) + 1)
        }
        return mention
    }
}
