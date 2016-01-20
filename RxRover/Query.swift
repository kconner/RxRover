//
//  Query.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

// Query parameters for requesting a list of photos.
// In this app we find the photos for a particular camera on a particular mission sol.

struct Query {

    var sol: Int // Mission sol (Mars day), valid within 1...Rover.solMax.
    var cameraName: String // Valid when it matches one of Rover.cameras' names.

    // URL for the API request specified by these query parameters.
    func URLWithAPIKey(APIKey: String) -> NSURL {
        guard let solComponent = String(sol).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
            let cameraNameComponent = cameraName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
            let APIKeyComponent = APIKey.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            else
        {
            preconditionFailure("Failed to encode URL query components.")
        }

        let URLString = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=\(solComponent)&camera=\(cameraNameComponent)&api_key=\(APIKeyComponent)"
        guard let URL = NSURL(string: URLString) else {
            preconditionFailure("Failed to make a valid URL: \(URLString)")
        }

        return URL
    }

}

extension Query: Equatable {}

func ==(lhs: Query, rhs: Query) -> Bool {
    return lhs.sol == rhs.sol && lhs.cameraName == rhs.cameraName
}
