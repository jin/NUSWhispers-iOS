//
//  MasterViewController.swift
//  NUSWhispers
//
//  Created by jin on 28/4/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import SVProgressHUD
import TTTAttributedLabel

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil

    var sections = [
        Section.Featured,
        .Popular,
        .Latest
    ]

    var categories = [
        Section.Advice,
        .Funny,
        .LostAndFound,
        .Nostalgia,
        .Rant,
        .Romance
    ]
        

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers.last!.topViewController as? DetailViewController
        }

        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView!.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)

        let titleLogo = UIImage(named: "card_logo")
        navigationItem.titleView = UIImageView(image: titleLogo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                var section: Section? = nil
                switch indexPath.section {
                case 0:
                    section = sections[indexPath.row]
                case 1:
                    section = categories[indexPath.row]
                default:
                    assertionFailure("Invalid section")
                }

                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.section = section
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sections.count
        } else {
            return categories.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if indexPath.section == 0 {
            let sectionName = sections[indexPath.row].rawValue as String
            cell.textLabel!.text = sectionName.capitalizedString
        } else {
            let categoryName = categories[indexPath.row].rawValue as String
            cell.textLabel!.text = categoryName.capitalizedString

        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SVProgressHUD.show()
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        SVProgressHUD.dismiss()
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 52
        } else {
            return 22
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "NUSWhispers"
        case 1:
            return "CATEGORIES"
        default:
            return ""
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let label = TTTAttributedLabel()
            label.font = UIFont(name: "Avenir-Black", size: 24)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = NSTextAlignment.Center
            let text = self.tableView(tableView, titleForHeaderInSection: section)! as NSString

            label.setText(text, afterInheritingLabelAttributesAndConfiguringWithBlock: { (mutString: NSMutableAttributedString!) in
                let yellowRange = text.rangeOfString("Whispers")
                mutString.addAttribute(String(kCTForegroundColorAttributeName), value: UIColor.yellowColor(), range: yellowRange)
                return mutString
            })

            return label
        case 1:
            let label = TTTAttributedLabel()
            label.font = UIFont(name: "Avenir-Black", size: 12)
            label.textColor = AppColors.DarkBlue
            label.textAlignment = NSTextAlignment.Center
            label.text = self.tableView(tableView, titleForHeaderInSection: section)
            return label
        default:
            return .None
        }
    }

}

