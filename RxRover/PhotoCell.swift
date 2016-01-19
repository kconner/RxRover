//
//  PhotoCell.swift
//  RxRover
//
//  Created by Kevin Conner on 1/19/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift

final class PhotoCell: UICollectionViewCell {

    static let cellIdentifier = "PhotoCell"

    let photo = Variable<Photo?>(nil)
    let disposeBag = DisposeBag()

    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        conjureDemons()
    }

    // MARK: Helpers

    private func conjureDemons() {
        // When the photo is set, pull its image from its image cache entry. When cleared, clear the photo.
        photo.asObservable()
            .map { photo -> Observable<UIImage?> in
                guard let photo = photo else {
                    return .just(nil)
                }

                return ImageCache.sharedCache[photo]
            }
            .switchLatest()
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] image in
                // Not sure how this can ever be nil when we are observing on the main thread?
                // Self should destroy the observer when disposing.
                self?.imageView.image = image
            }
            .addDisposableTo(disposeBag)
    }

}
