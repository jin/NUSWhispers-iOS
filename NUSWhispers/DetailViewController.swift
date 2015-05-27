//
//  DetailViewController.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import SVProgressHUD

class DetailViewController: UIViewController {

    weak var whispersTableViewController: WhispersTableViewController?

    var section: Section? = Section.Featured {
        didSet {
            sectionName = section!.rawValue as String
        }
    }

    private var sectionName: String? {
        didSet {
            self.configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }

    func configureView() {
        if let name: String = self.sectionName {
            title = name.capitalizedString
        }
    }

    override func viewWillDisappear(animated: Bool) {
        SVProgressHUD.dismiss()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWhispers" {
            whispersTableViewController = segue.destinationViewController as? WhispersTableViewController
            whispersTableViewController!.section = section
            whispersTableViewController!.detailViewController = self
        }
    }

}