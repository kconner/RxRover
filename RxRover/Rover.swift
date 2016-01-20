//
//  Rover.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

// Details about the Curiosity rover and its mission status.
// solMax and cameras specify the possible Query parameters.

struct Rover {

    let name: String
    let solMax: Int // The number of sols (Mars days) the mission has lasted so far.
    let cameras: [Camera]

    // A Rover we ship with the app so we have something to query for at launch.
    static let defaultRover: Rover = {
        return Rover.roverFromJSONFile(NSBundle.mainBundle().pathForResource("defaultRover", ofType: "json")!)!
    }()

    // Query parameters to use by default.
    var defaultQuery: Query {
        guard let firstCamera = cameras.first else {
            preconditionFailure("Rover should have at least one camera.")
        }

        let query = Query(sol: solMax, cameraName: firstCamera.name)
        assert(queryIsValid(query), "Default query for a Rover should always be valid.")
        return query
    }

    // Given the options specified by the Rover, are the Query's parameters valid?
    func queryIsValid(query: Query) -> Bool {
        return 0 <= query.sol && query.sol <= solMax && cameras.contains { camera in
            return camera.name == query.cameraName
        }
    }

    // Map a Rover from deserialized JSON.
    static func roverFromPlistValue(value: AnyObject?) -> Rover? {
        guard let dictionary = MapPlist.dictionary(value),
            let name = MapPlist.string(dictionary["name"]),
            let solMax = MapPlist.int(dictionary["max_sol"]),
            let cameras = MapPlist.array(Camera.cameraFromPlistValue)(dictionary["cameras"])
            else
        {
            assertionFailure("Invalid Rover JSON: \(value)")
            return nil
        }

        return Rover(name: name, solMax: solMax, cameras: cameras)
    }

    // Map a rover from JSON data.
    static func roverFromJSONData(data: NSData) -> Rover? {
        do {
            let plistValue = try NSJSONSerialization.JSONObjectWithData(data, options: [])
            return roverFromPlistValue(plistValue)
        } catch {
            assertionFailure("Couldn't deserialize JSON.")
            return nil
        }
    }

    // Map a rover from a JSON file.
    static func roverFromJSONFile(path: String) -> Rover! {
        guard let data = NSData(contentsOfFile: path) else {
            assertionFailure("Couldn't read from \(path).")
            return nil
        }

        return roverFromJSONData(data)
    }

}
