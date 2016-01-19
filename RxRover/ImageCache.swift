//
//  ImageCache.swift
//  RxRover
//
//  Created by Kevin Conner on 1/19/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift

final class ImageCache {

    static let sharedCache = ImageCache()

    private var imagesByPhoto: [Photo: Variable<UIImage?>] = [:]
    private let disposeBag = DisposeBag()

    subscript(photo: Photo) -> Observable<UIImage?> {
        if let image = imagesByPhoto[photo] {
            return image.asObservable()
        }

        let image = Variable<UIImage?>(nil)
        imagesByPhoto[photo] = image

        Requests.imageRequestWithURL(photo.photoURL)
            .retry(3)
            .observeOn(MainScheduler.instance)
            .catchError { [unowned self] error -> Observable<UIImage?> in
                // If we fail to get the image, remove this empty entry from the cache.
                self.imagesByPhoto[photo] = nil
                return .just(nil)
            }
            .bindTo(image)
            .addDisposableTo(disposeBag)

        return image.asObservable()
    }

}
