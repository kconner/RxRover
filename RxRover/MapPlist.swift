//
//  MapPlist.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

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

    class func array<T>(value: AnyObject?) -> ((AnyObject) -> T?) -> [T]? {
        return { mapItem in
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
