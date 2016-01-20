//
//  Photo.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

// A photo record returned from the API.

struct Photo {

    let identifier: Int // Unique ID.
    let photoURL: NSURL

    static func photoFromPlistValue(value: AnyObject?) -> Photo? {
        guard let dictionary = MapPlist.dictionary(value),
            let identifier = MapPlist.int(dictionary["id"]),
            let photoURL = MapPlist.URL(dictionary["img_src"])
            else
        {
            assertionFailure("Invalid Photo JSON: \(value)")
            return nil
        }
        
        return Photo(identifier: identifier, photoURL: photoURL)
    }

}

extension Photo: Hashable {

    var hashValue: Int {
        return identifier
    }

}

func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.identifier == rhs.identifier
}
