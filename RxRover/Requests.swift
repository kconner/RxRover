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
        let URL = query.URLWithAPIKey(APIKey)

        return Observable.create { observer in
            NSURLSession.sharedSession().dataTaskWithURL(URL) { (data, _, error) in
                if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    do {
                        let plistValue = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        guard let photos = MapPlist.array(plistValue)(Photo.photoFromPlistValue) else {
                            observer.onError(NSError(domain: "RxRover.Requests", code: 1, userInfo: nil))
                            return
                        }
                        
                        observer.on(.Next(photos))
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }.resume()

            return NopDisposable.instance
        }
    }

}
