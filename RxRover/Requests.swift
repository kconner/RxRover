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

    // TODO: Get a real API key
    static let APIKey = "DEMO_KEY"

    class func photosRequestWithQuery(query: Query) -> Observable<[Photo]> {
        let request = NSURLRequest(URL: query.URLWithAPIKey(APIKey))

        return NSURLSession.sharedSession().rx_data(request).map { data in
            let plistValue = try NSJSONSerialization.JSONObjectWithData(data, options: [])

            guard let photos = MapPlist.array(plistValue)(Photo.photoFromPlistValue) else {
                throw NSError(domain: "RxRover.Requests", code: 1, userInfo: nil)
            }

            return photos
        }
    }

}
