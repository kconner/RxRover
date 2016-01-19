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
        let title: String
        let photos: [Photo]
    }

    // The rover affects our querying options.
    private let rover = Variable(Rover.defaultRover)

    // The query affects requests, which affect the data.
    private let query = Variable(Query(sol: 1000000, cameraName: "BogusCam"))

    // The data affects what the collection view displays.
    private let data = Variable(Data(title: "Not yet loaded.", photos: []))

    private let disposeBag = DisposeBag()

    @IBOutlet var cameraButtonItem: UIBarButtonItem!
    @IBOutlet var solStepper: UIStepper!
    @IBOutlet var itemSizeSlider: UISlider!

    // MARK: Helpers

    private func conjureDemons() {
        // When the rover changes, validate the query, and if it's invalid, replace it.
        // When the rover changes, update the stepper's limit.
        rover.asObservable().subscribeNext { [unowned self] newRover in
            if !newRover.queryIsValid(self.query.value) {
                self.query.value = newRover.defaultQuery
            }

            self.solStepper.maximumValue = Double(newRover.solMax)
        }.addDisposableTo(disposeBag)

        // When the query changes, run the request, compose data from its result, and save it.
        query.asObservable().map { [unowned self] query -> Observable<Data> in
            let title = "Sol \(query.sol)"
            self.data.value = Data(title: title, photos: [])

            return Requests.photosRequestWithQuery(query).map { [unowned self] (rover, photos) in
                // As a side effect, if we found a rover, use it to update our knowledge of available cameras and sols for querying.
                if let rover = rover {
                    self.rover.value = rover
                }

                return Data(title: title, photos: photos)
            }.catchErrorJustReturn(Data(title: "Error!", photos: []))
        }.switchLatest().bindTo(data).addDisposableTo(disposeBag)

        // When the data changes, show its title and reload the collection view.
        data.asObservable().observeOn(MainScheduler.instance).subscribeNext { [unowned self] data in
            self.navigationItem.title = data.title
            self.collectionView?.reloadData()
        }.addDisposableTo(disposeBag)

        // When the stepper changes, update the query.
        solStepper.value = Double(query.value.sol)
        solStepper.rx_value.map(Int.init).observeOn(MainScheduler.instance).subscribeNext { [unowned self] sol in
            self.query.value.sol = sol
        }.addDisposableTo(disposeBag)

        // When the item size slider changes, update the item size in the layout.
        itemSizeSlider.rx_value.map(CGFloat.init).distinctUntilChanged().observeOn(MainScheduler.instance).subscribeNext { [unowned self] itemSize in
            guard let layout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
                preconditionFailure("Wrong collection view layout class")
            }

            layout.itemSize = CGSize(width: itemSize, height: itemSize)
        }.addDisposableTo(disposeBag)
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: itemSizeSlider),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
        ]
        navigationController?.toolbarHidden = false

        collectionView?.registerNib(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: PhotoCell.cellIdentifier)

        conjureDemons()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.photos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photo = data.value.photos[indexPath.row]
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCell.cellIdentifier, forIndexPath: indexPath) as! PhotoCell

        photoCell.photo.value = photo

        return photoCell
    }

    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photoCell = cell as! PhotoCell

        photoCell.photo.value = nil
    }

}
