//
//  PhotoCell.swift
//  RxRover
//
//  Created by Kevin Conner on 1/19/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift

// A collection view cell in the photo grid.
// The preparer should set a Photo when the cell appears and clear it when the cell leaves the screen.
// The cell observes the Photo and uses the ImageCache to get images that it sets on its imageView.

final class PhotoCell: UICollectionViewCell {

    static let cellIdentifier = "PhotoCell"

    let photo = Variable<Photo?>(nil)

    @IBOutlet var imageView: UIImageView!

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        bindObservables()
    }

    // MARK: Helpers

    private func bindObservables() {
        // When the photo changes, subscribe to that photo's image sequence in the ImageCache.
        // When the cache produces an image, show it in the imageView.
        photo.asObservable()
            .distinctUntilChanged(==)
            // Map each photo to an image sequence.
            // Then watch only the sequence mapped from the latest photo.
            .flatMapLatest { photo -> Observable<UIImage?> in
                // For a nil, map to a sequence with one nil image.
                guard let photo = photo else {
                    return .just(nil)
                }

                // For a photo, map to an image sequence from the cache.
                return ImageCache.sharedCache[photo]
            }
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] image in
                // Show or clear the image.
                self?.imageView.image = image
            }
            .addDisposableTo(disposeBag)
    }

}
