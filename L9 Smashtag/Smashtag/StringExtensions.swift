//
//  StringExtensions.swift
//  Smashtag
//
//  Created by Cory Steers on 10/16/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

extension String {
    func findURLs() -> [String] {
        var urls: [String] = []
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url.absoluteString)
                }
            })
        } catch {
            print("looking for URLs in \(self) has results in error: \(error)")
        }
        return urls
    }
}

extension String {
    func extractRegex(using expression: String) -> [String] {
        var result: [String] = []
        
        let regex = try! NSRegularExpression(pattern: expression, options: [])
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        for match in matches {
            result.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length:match.range.length)))
        }
        return result
    }
}

