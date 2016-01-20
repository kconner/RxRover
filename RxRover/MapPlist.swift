//
//  MapPlist.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

// A package of helper methods for parsing property list values that were deserialized from JSON.
// Mapping fuctions take the form of (deserialized JSON value) -> Optional<native type>.
// Some model types have mapping functions that use these helpers and one another to map whole model objects.

final class MapPlist {

    class func dictionary(value: AnyObject?) -> NSDictionary? {
        return value as? NSDictionary
    }

    class func int(value: AnyObject?) -> Int? {
        return value as? Int
    }

    class func string(value: AnyObject?) -> String? {
        return value as? String
    }

    class func URL(value: AnyObject?) -> NSURL? {
        guard let URLString = string(value) else {
            return nil
        }

        return NSURL(string: URLString)
    }

    // Given a function that maps a JSON item to a native value, return a function that maps an array of such items.
    class func array<T>(mapItem: (AnyObject) -> T?) -> (AnyObject?) -> [T]? {
        return { value in
            guard let array = value as? NSArray else {
                return nil
            }

            var result: [T] = []

            for item in array {
                guard let mappedItem = mapItem(item) else {
                    assertionFailure("Could not map item: \(item)")
                    return nil
                }

                result.append(mappedItem)
            }

            return result
        }
    }

}
