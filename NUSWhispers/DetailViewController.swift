//
//  DetailViewController.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var whispersTableViewController: WhispersTableViewController?
    var section: Section? = Section.Featured {
        didSet {
            sectionName = section!.rawValue as String
        }
    }

    private var sectionName: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let name: String = self.sectionName {
            title = name.capitalizedString
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWhispers" {
            whispersTableViewController = segue.destinationViewController as? WhispersTableViewController
            whispersTableViewController!.section = section
        }
    }


}

