//
//  Movie.swift
//  Rotten Tomatoes
//
//  Created by Chris Cruz on 4/20/15.
//  Copyright (c) 2015 Chris Cruz. All rights reserved.
//

import Foundation

class Movie {
    var mpaaRating: String?
    var title : String?
    var synopsis : String?
    var imageUrl :NSURL?
    
    convenience init(dictionary: NSDictionary) {
        self.init()
        
        title = dictionary.valueForKey("title") as? String
        synopsis = dictionary.valueForKey("synopsis") as? String
        mpaaRating = dictionary.valueForKeyPath("mpaa_rating") as? String
        imageUrl = getImageUrlFromString(dictionary.valueForKeyPath("posters.original") as! String)
    }
    
    func getImageUrlFromString(string : String) -> NSURL {
        var posterUrlString = string.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        var range = posterUrlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            posterUrlString = posterUrlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        return NSURL(string: posterUrlString)!
    }
}