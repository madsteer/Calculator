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
            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.characters.count), using: { (result, _, _) in
                if let match = result, let url = match.url {
                    urls.append(url.absoluteString)
                }
            })
        } catch {
            print("looking for URLs in \(self) has results in error: \(error)")
        }
        return urls
    }
    
//    func nsRange(from range: Range<String.Index>) -> NSRange {
//        let from = range.lowerBound.samePosition(in: utf16)
//        let to = range.upperBound.samePosition(in: utf16)
//        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
//                       length: utf16.distance(from: from, to: to))
//    }
    
    func extractRegex(using expression: String) -> [String] {
        var result: [String] = []
        
        let regex = try! NSRegularExpression(pattern: expression, options: [])
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
        for match in matches {
            result.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length:match.range.length)))
        }
        return result
    }
    
//    func range(from nsRange: NSRange) -> Range<String.Index>? {
//        guard
//            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
//            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
//            let from = from16.samePosition(in: self),
//            let to = to16.samePosition(in: self)
//            else { return nil }
//        return from ..< to
//    }
}

