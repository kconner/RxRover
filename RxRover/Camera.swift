//
//  Camera.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

struct Camera {
    
    let name: String
    let fullName: String
    
    static func cameraFromPlistValue(value: AnyObject?) -> Camera? {
        guard let dictionary = MapPlist.dictionary(value),
            let name = MapPlist.string(dictionary["name"]),
            let fullName = MapPlist.string(dictionary["full_name"])
            else
        {
            assertionFailure("Invalid Camera JSON: \(value)")
            return nil
        }
        
        return Camera(name: name, fullName: fullName)
    }
    
}

extension Camera: Equatable {}

func ==(lhs: Camera, rhs: Camera) -> Bool {
    return lhs.name == rhs.name
}
