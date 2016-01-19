//
//  Query.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

struct Query {

    var sol: Int
    var cameraName: String

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
