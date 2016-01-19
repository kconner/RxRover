//
//  PhotoGridViewController.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

final class PhotoGridViewController: UICollectionViewController {

    var rover: Rover = Rover.roverFromJSONFile(NSBundle.mainBundle().pathForResource("defaultRover", ofType: "json")!)!

    @IBOutlet var cameraButtonItem: UIBarButtonItem!
    @IBOutlet var solStepper: UIStepper!

    // MARK: Helpers

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
