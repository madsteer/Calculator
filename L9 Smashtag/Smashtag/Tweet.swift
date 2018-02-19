//
//  Tweet.swift
//  Smashtag
//
//  Created by Cory Steers on 1/12/18.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    class func findOrCreateTweet(matching desiredTweet: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", desiredTweet.identifier)
        
        let existingTweets = try context.fetch(request)
        if existingTweets.count > 0 {
            assert(existingTweets.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
            return existingTweets[0]
        } else {
            let tweet = Tweet(context: context)
            tweet.unique = desiredTweet.identifier
            tweet.text = desiredTweet.text
            tweet.created = desiredTweet.created as NSDate
            return tweet
        }
    }
    
    class func findTweetAndCheckMentions(for desiredTweet: Twitter.Tweet, using searchTerm: String, in context: NSManagedObjectContext) throws -> Tweet {
        let persistedTweet = try findOrCreateTweet(matching: desiredTweet,in: context)
        let hashtags = desiredTweet.hashtags
        for hashtag in hashtags{
            _ = try? Mention.checkMention(for: persistedTweet, with: hashtag.keyword, and: "Hashtags", using: searchTerm, in: context)
        }
        let users = desiredTweet.userMentions
        for user in users {
            _ = try? Mention.checkMention(for: persistedTweet, with: user.keyword, and: "Users", using: searchTerm, in: context)
        }
        
        let userScreenName = "@" + desiredTweet.user.screenName
        _ = try? Mention.checkMention(for: persistedTweet, with: userScreenName, and: "Users", using: searchTerm, in: context)
        
        return persistedTweet
    }
    
    class func newTweets( for newTweets: [Twitter.Tweet], using searchTerm: String, in context: NSManagedObjectContext) throws {
        var newTweetIdentifiers = Set ( newTweets.map {$0.identifier} )
        
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "any mentions.searchTerm contains[c] %@ and unique IN %@", searchTerm, newTweetIdentifiers )
        
        let savedTweetIdentifiers = try Set ( context.fetch(request).flatMap({ $0.unique}) )
        
        newTweetIdentifiers.subtract(savedTweetIdentifiers)
        print ("-----------number of new items \(newTweetIdentifiers.count)-----")
        
        for newTweetIdentifier in newTweetIdentifiers{
            if let index = newTweets.index(where: {$0.identifier == newTweetIdentifier}) {
                _ = try? Tweet.findTweetAndCheckMentions(for: newTweets[index], using: searchTerm, in: context)
            }
        }
    }
    
    private struct Constants {
        static let OneWeekInSeconds  = -60*60*24*7
    }
    
    class func removeOldTweets(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        let weekAgo = Date(timeIntervalSinceNow:
            TimeInterval(Constants.OneWeekInSeconds))
        request.predicate = NSPredicate(format: "created < %@", weekAgo as CVarArg)
        
        if let tweets = try? context.fetch(request)  {
            for tweet in tweets {
                context.delete(tweet)
            }
            if tweets.count > 0 {
                print ("Removed \(tweets.count) Tweets")
            }
        }
        try? context.save()
    }
}
