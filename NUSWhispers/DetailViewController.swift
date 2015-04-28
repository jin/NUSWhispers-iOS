//
//  DetailViewController.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var sectionName: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let name: String = self.sectionName {
            if let label = self.detailDescriptionLabel {
                label.text = name
                title = name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        view.backgroundColor = UIColor(red: 38, green: 124, blue: 191, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

