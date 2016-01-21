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

// A view for viewing photos with controls for querying photos.
// There are a lot of reactive behaviors in this view:
// The user defines the Query by adjusting the stepper and using the Camera list modal view.
// Query changes fire requests that produce new PhotoData and Rovers.
// Rover changes affect which Queries are valid, as reflected in the stepper's limits and Camera list's options.
// PhotoData changes update the collection view and the navigation bar title.
// Slider adjustments affect the collection view layout.

final class PhotoGridViewController: UICollectionViewController {

    private struct PhotoData {
        let title: String
        let photos: [Photo]
    }

    @IBOutlet var solStepper: UIStepper!
    @IBOutlet var itemSizeSlider: UISlider!

    private let rover = Variable(Rover.defaultRover)
    private let query = Variable(Query(sol: 1000000, cameraName: "BogusCam"))
    private let photoData = Variable(PhotoData(title: "Not yet loaded.", photos: []))

    private let disposeBag = DisposeBag()

    // MARK: Helpers

    private func bindObservables() {
        // When the rover changes, update the stepper's limit.
        // When the rover changes, use its new sol range and camera list to validate the query.
        // If it's invalid, replace it with a valid query.
        rover.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeNext { [unowned self] newRover in
                self.solStepper.maximumValue = Double(newRover.solMax)

                if !newRover.queryIsValid(self.query.value) {
                    let query = newRover.defaultQuery
                    self.query.value = query
                    self.solStepper.value = Double(query.sol)
                }
            }
            .addDisposableTo(disposeBag)

        // When the stepper changes, update the query.
        solStepper.rx_value
            .map(Int.init)
            .subscribeNext { [unowned self] sol in
                self.query.value.sol = sol
            }
            .addDisposableTo(disposeBag)

        // When the query changes, run a request and update photoData.
        query.asObservable()
            .distinctUntilChanged()
            // For each new query, produce a sequence of PhotoData based on a new request.
            // Then only watch the sequence for the most recent request.
            // That is, if we run two requests quickly, forget about the first one.
            .flatMapLatest { query -> Observable<PhotoData> in
                let title = "Sol \(query.sol)"
                return Requests.photosRequestWithQuery(query)
                    .map { [unowned self] (photos, rover) in
                        // As a side effect, if we found a rover, use it to update our knowledge of available cameras and sols for querying.
                        if let rover = rover {
                            self.rover.value = rover
                        }
                        
                        return PhotoData(title: title, photos: photos)
                    }
                    // If the request produces an error, represent that as a title about there being no results.
                    .catchErrorJustReturn(PhotoData(title: "No Results", photos: []))
                    // Before producing a value from the request, produce a value with no photos.
                    // This updates the title immediately and clears the collection view until photos arrive.
                    .startWith(PhotoData(title: title, photos: []))
            }
            .bindTo(photoData)
            .addDisposableTo(disposeBag)

        // When photoData changes, show its title and reload the collection view.
        photoData.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribeNext { [unowned self] photoData in
                self.navigationItem.title = photoData.title
                self.collectionView?.reloadData()
            }
            .addDisposableTo(disposeBag)

        // When the item size slider changes, update the collection view layout's item size.
        itemSizeSlider.rx_value
            .distinctUntilChanged()
            .map(CGFloat.init)
            .observeOn(MainScheduler.instance)
            .subscribeNext { [unowned self] (itemSize: CGFloat) -> Void in
                guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
                    preconditionFailure("Wrong collection view layout class")
                }
                
                layout.itemSize = CGSize(width: itemSize, height: itemSize)
            }
            .addDisposableTo(self.disposeBag)
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: itemSizeSlider),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
        ]

        collectionView?.registerNib(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: PhotoCell.cellIdentifier)

        bindObservables()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentCameraList" {
            guard let navigationController = segue.destinationViewController as? UINavigationController,
                let cameraListViewController = navigationController.topViewController as? CameraListViewController
                else
            {
                preconditionFailure("Bogus view controllers in storyboard.")
            }

            cameraListViewController.rover = rover.value
            cameraListViewController.selectedCameraName.value = query.value.cameraName

            // When the selected camera changes, update the query.
            cameraListViewController.selectedCameraName.asObservable()
                .subscribeNext { [unowned self] selectedCameraName in
                    self.query.value.cameraName = selectedCameraName
                }
                .addDisposableTo(disposeBag)
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoData.value.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCell.cellIdentifier, forIndexPath: indexPath) as! PhotoCell
        photoCell.photo.value = photoData.value.photos[indexPath.row]
        return photoCell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photoCell = cell as! PhotoCell
        photoCell.photo.value = nil
    }

}
