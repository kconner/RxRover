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

    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.lightGrayColor()

        conjureDemons()
    }

    // MARK: Helpers

    private func conjureDemons() {
        // TODO: When photo changes, fetch the image from the image cache and display it
    }

}
