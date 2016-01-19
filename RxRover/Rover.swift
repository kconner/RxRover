//
//  Rover.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

struct Rover {
    
    let name: String
    let solMax: Int
    let cameras: [Camera]

    var defaultQuery: Query {
        guard let firstCamera = cameras.first else {
            preconditionFailure("Rover should have at least one camera.")
        }

        return Query(sol: solMax, cameraName: firstCamera.name)
    }

    static func roverFromPlistValue(value: AnyObject?) -> Rover? {
        guard let dictionary = MapPlist.dictionary(value),
            let name = MapPlist.string(dictionary["name"]),
            let solMax = MapPlist.int(dictionary["max_sol"]),
            let cameras = MapPlist.array(dictionary["cameras"])(Camera.cameraFromPlistValue)
            else
        {
            assertionFailure("Invalid Rover JSON: \(value)")
            return nil
        }

        return Rover(name: name, solMax: solMax, cameras: cameras)
    }

    static func roverFromJSONData(data: NSData) -> Rover? {
        do {
            let plistValue = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return roverFromPlistValue(plistValue)
        } catch {
            assertionFailure("Couldn't deserialize JSON.")
            return nil
        }
    }

    static func roverFromJSONFile(path: String) -> Rover! {
        guard let data = NSData(contentsOfFile: path) else {
            assertionFailure("Couldn't read from \(path).")
            return nil
        }

        return roverFromJSONData(data)
    }

}
