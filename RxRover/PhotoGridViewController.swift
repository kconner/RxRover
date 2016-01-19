//
//  PhotoGridViewController.swift
//  RxRover
//
//  Created by Kevin Conner on 1/18/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PhotoGridViewController: UICollectionViewController {

    struct Data {
        let heading: String
        let photos: [Photo]
    }

    // The rover affects our querying options.
    var rover = Rover.roverFromJSONFile(NSBundle.mainBundle().pathForResource("defaultRover", ofType: "json")!)!

    // The query affects requests, which affect the data.
    lazy var query: Query = {
        return self.rover.defaultQuery
    }()

    // The data affects what the collection view displays.
    var data = Data(heading: "Not yet loaded.", photos: [])

    // Item size affects how the view is laid out.
    var itemSize: CGFloat = 10.0

    @IBOutlet var cameraButtonItem: UIBarButtonItem!
    @IBOutlet var solStepper: UIStepper!

    // MARK: Helpers

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO:
        // When the rover changes, validate the query, and if it's invalid, replace it.
        // When the query changes, re-run the request.
        // When the request completes, parse the JSON and set the data.
        // When the data changes, reload the collection view.
        // When the item size changes, change the collection view layout.

        // Implement collection view data source and delegate methods.
        // When a cell comes on the screen, subscribe it to its image subject, unsubscribing from another if necessary.
        // When a cell leaves the screen, unsubscribe it.

        // Run the request.
    }

}
