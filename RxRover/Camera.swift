//
//  Camera.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

// A camera on the Rover.

struct Camera {
    
    let name: String // Abbreviated name. Also an API query parameter.
    let fullName: String // Full display name.
    
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
