//
//  ImageCache.swift
//  RxRover
//
//  Created by Kevin Conner on 1/19/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// An asynchronous read-through image cache.
// To use it, call ImageCache.sharedCache[photo].subscribeNext { image in … }.
// When a cached image's Observable is requested, the subscription just gets the image.
// When an uncached image's Observable is requested, the image is requested at that time.
// In this case the subscription first gets nil, then the image when request completes.

final class ImageCache {

    static let sharedCache = ImageCache()

    private var imageSequencesByPhoto: [Photo: Driver<UIImage?>] = [:]
    private let disposeBag = DisposeBag()

    // Get an Observable that produces the image if it's cached, or else produces nil and then the image after downloading.
    subscript(photo: Photo) -> Driver<UIImage?> {
        // If we already requested this image, return its sequence.
        // It may not be done downloading yet, but we won't start any unnecessary requests.
        // Instead, we'll let the second caller subscribe to the same result as the one request.
        if let sequence = imageSequencesByPhoto[photo] {
            return sequence
        }

        // Create a Variable for the image.
        let subject = Variable<UIImage?>(nil)

        // Run a request that downloads and saves the image in the Variable.
        Requests.imageRequestWithURL(photo.photoURL)
            .catchError { [unowned self] error -> Observable<UIImage?> in
                // If we fail to get the image, remove this empty Variable from the cache and produce nil.
                // The next time this photo is requested, we will start fresh with a new Variable and request.
                self.imageSequencesByPhoto[photo] = nil
                return .just(nil)
            }
            .bindTo(subject)
            .addDisposableTo(disposeBag)

        // Store the sequence that reads the Variable as a Driver, which will always deliver on the main thread.
        let sequence = subject.asDriver()
        imageSequencesByPhoto[photo] = sequence

        // Return an Observable-only view of the Variable.
        // Subscribers in this case will first see nil, then the image.
        return sequence
    }

}
