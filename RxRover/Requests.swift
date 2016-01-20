//
//  Requests.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift

// A package of methods that make network requests.
// To receive data from these methods, subscribe to the Observables they return.

final class Requests {

    // My NASA API key. If you intend to write your own app, you should get your own.
    static let APIKey = "PydObPweexsrxOrh5qrDuvTGMwoJEtnwxEFP7tFZ"

    // Requests photos for given query parameters.
    // Returns an Observable that will produce a list of Photos and, if there were any, a Rover.
    class func photosRequestWithQuery(query: Query) -> Observable<([Photo], Rover?)> {
        let request = NSURLRequest(URL: query.URLWithAPIKey(APIKey))

        return NSURLSession.sharedSession().rx_data(request)
            .retry(2)
            .map { data in
                // Deserialize JSON data to a plist value.
                let plistValue = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                
                // Map the plist value to a list of native Photos.
                guard let dictionary = MapPlist.dictionary(plistValue),
                    let photos = MapPlist.array(Photo.photoFromPlistValue)(dictionary["photos"]) else {
                        throw NSError(domain: "RxRover.Requests", code: 1, userInfo: nil)
                }
                
                // If the plist value has any photos, map the first one to a native Rover.
                if let photosArray = dictionary["photos"] as? NSArray,
                    let firstPhoto = photosArray.firstObject as? NSDictionary,
                    let rover = Rover.roverFromPlistValue(firstPhoto["rover"])
                {
                    return (photos, rover)
                } else {
                    return (photos, nil)
                }
            }
    }

    // Returns an Observable that will produce an image when it's downloaded.
    class func imageRequestWithURL(URL: NSURL) -> Observable<UIImage?> {
        let request = NSURLRequest(URL: URL)
        return NSURLSession.sharedSession().rx_data(request)
            .retry(2)
            .map(UIImage.init)
    }

}
