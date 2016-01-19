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
//    var roverPublisher = PublishSubject<Rover>()
    var rover = Rover.defaultRover

    // The query affects requests, which affect the data.
//    var queryPublisher = PublishSubject<Query>()
    lazy var query: Query = {
        return self.rover.defaultQuery
    }()

    // The data affects what the collection view displays.
    var data = Data(heading: "Not yet loaded.", photos: [])

    // Item size affects how the view is laid out.
    var itemSize: CGFloat = 10.0

    let disposeBag = DisposeBag()

    @IBOutlet var cameraButtonItem: UIBarButtonItem!
    @IBOutlet var solStepper: UIStepper!

    // MARK: Helpers

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // When the rover changes, validate the query, and if it's invalid, replace it.
        // When the query changes, re-run the request and set the data.
        // When the data changes, reload the collection view.
        // When the item size changes, change the collection view layout.

        // Implement collection view data source and delegate methods.
        // When a cell comes on the screen, subscribe it to its image subject, unsubscribing from another if necessary.
        // When a cell leaves the screen, unsubscribe it.

        // Run the request.
    }

}
