//
//  Photo.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

struct Photo {

    let identifier: Int
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


