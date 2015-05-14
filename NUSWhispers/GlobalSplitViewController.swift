//
//  GlobalSplitViewController.swift
//  NUSWhispers
//
//  Created by jin on 15/5/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit

class GlobalSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
    }

}
