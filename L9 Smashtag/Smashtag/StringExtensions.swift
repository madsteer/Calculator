//
//  StringExtensions.swift
//  Smashtag
//
//  Created by Cory Steers on 10/16/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

extension String {
    func findEncodedOffset(of character: Character) -> Int? {
        return index(of: character)?.encodedOffset
    }
    func findEncodedOffset(of string: String) -> Int? {
        return range(of: string)?.lowerBound.encodedOffset
    }
    
    func findIndex(of character: Character) -> Int? {
        return findEncodedOffset(of: character)
    }
    func findIndex(of string: String) -> Int? {
        return findEncodedOffset(of: string)
    }
}

extension String {
    func substring(after char: Character) -> String? {
        guard let index = self.findIndex(of: char) else { return nil }
        let offset = index + 1
        let startPosition = self.index(self.startIndex, offsetBy: offset)
        return String(self[startPosition...])
    }
}

//extension String {
//    func findURLs() -> [String] {
//        var urls: [String] = []
//        do {
//            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//            detector.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count), using: { (result, _, _) in
//                if let match = result, let url = match.url {
//                    urls.append(url.absoluteString)
//                }
//            })
//        } catch {
//            print("looking for URLs in \(self) has results in error: \(error)")
//        }
//        return urls
//    }
//}

//extension String {
//    func findEncodedOffset(of character: Character) -> Int? {
//        return index(of: character)?.encodedOffset
//    }
//    func findEncodedOffset(of string: String) -> Int? {
//        return range(of: string)?.lowerBound.encodedOffset
//    }
//
//    func findIndex(of character: Character) -> Int? {
//        return findEncodedOffset(of: character)
//    }
//    func findIndex(of string: String) -> Int? {
//        return findEncodedOffset(of: string)
//    }
//}

/*
extension String {
    func extractRegex(using expression: String) -> [String] {
        var result: [String] = []
        
//        let regex = try! NSRegularExpression(pattern: expression, options: [])
//        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        
        let matches = findMatches(for: expression)
        for match in matches {
            result.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length:match.range.length)))
        }
        return result
    }
}
 */

extension String {
    func findMatches(for expression: String) -> [NSTextCheckingResult] {
        if let regex = try? NSRegularExpression(pattern: expression, options: []) {
            return regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        }
        
        return []
    }
}

