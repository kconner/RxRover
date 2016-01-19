//
//  Requests.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift

final class Requests {

    static let APIKey = "PydObPweexsrxOrh5qrDuvTGMwoJEtnwxEFP7tFZ"

    class func photosRequestWithQuery(query: Query) -> Observable<(Rover?, [Photo])> {
        let request = NSURLRequest(URL: query.URLWithAPIKey(APIKey))

        return NSURLSession.sharedSession().rx_data(request).map { data in
            let plistValue = try NSJSONSerialization.JSONObjectWithData(data, options: [])

            guard let dictionary = MapPlist.dictionary(plistValue),
                let photos = MapPlist.array(dictionary["photos"])(Photo.photoFromPlistValue) else {
                throw NSError(domain: "RxRover.Requests", code: 1, userInfo: nil)
            }

            if let photosArray = dictionary["photos"] as? NSArray,
                let firstPhoto = photosArray.firstObject as? NSDictionary,
                let rover = Rover.roverFromPlistValue(firstPhoto["rover"])
            {
                return (rover, photos)
            } else {
                return (nil, photos)
            }
        }
    }

    class func imageRequestWithURL(URL: NSURL) -> Observable<UIImage?> {
        let request = NSURLRequest(URL: URL)
        return NSURLSession.sharedSession().rx_data(request).map { data in
            return UIImage(data: data)
        }
    }

}
