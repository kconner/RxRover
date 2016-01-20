//
//  CameraListViewController.swift
//  RxRover
//
//  Created by Kevin Conner on 1/19/16.
//  Copyright © 2016 Kevin Conner. All rights reserved.
//

import UIKit
import RxSwift

final class CameraListViewController: UITableViewController {

    var rover: Rover!
    let selectedCameraName = Variable("")

    private static let cellIdentifier = "CameraCell"

    // MARK: Helpers

    private func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        let camera = rover.cameras[indexPath.row]

        cell.textLabel?.text = "\(camera.name): \(camera.fullName)"
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.accessoryType = camera.name == selectedCameraName.value ? .Checkmark : .None
    }

    @IBAction func didTapCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "\(rover.name) Cameras"

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CameraListViewController.cellIdentifier)
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rover.cameras.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CameraListViewController.cellIdentifier, forIndexPath: indexPath)

        configureCell(cell, forIndexPath: indexPath)

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCameraName.value = rover.cameras[indexPath.row].name

        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let visibleCell = tableView.cellForRowAtIndexPath(indexPath) {
                configureCell(visibleCell, forIndexPath: indexPath)
            }
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dismissViewControllerAnimated(true, completion: nil)
    }

}
