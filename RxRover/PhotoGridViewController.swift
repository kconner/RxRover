//
//  PhotoGridViewController.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit

final class PhotoGridViewController: UICollectionViewController {

    enum Data {
        case Message(String)
        case Photos([Photo])
    }

    // The rover affects our querying options.
    var rover = Rover.roverFromJSONFile(NSBundle.mainBundle().pathForResource("defaultRover", ofType: "json")!)!

    // The query affects requests, which affect the data.
    lazy var query: Query = {
        return self.rover.defaultQuery
    }()

    // The data affects what the view displays.
    var data = Data.Message("Not yet loaded.")

    // Item size affects how the view is laid out.
    var itemSize: CGFloat = 10.0

    @IBOutlet var cameraButtonItem: UIBarButtonItem!
    @IBOutlet var solStepper: UIStepper!

    // MARK: Helpers

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
