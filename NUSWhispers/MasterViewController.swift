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
import SafariServices

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil

    var sections = [
        (Section.Featured, UIImage(named: "icon_featured")!),
        (.Popular, UIImage(named: "icon_popular")!),
        (.Latest, UIImage(named: "icon_latest")!)
    ]

    var categories = [
        (Section.Advice, UIImage(named: "icon_advice")!),
        (.Funny, UIImage(named: "icon_funny")!),
        (.LostAndFound, UIImage(named: "icon_lost_and_found")!),
        (.Nostalgia, UIImage(named: "icon_nostalgia")!),
        (.Rant, UIImage(named: "icon_rant")!),
        (.Romance, UIImage(named: "icon_romance")!)
    ]

    var others = [
        (Section.NewConfession, UIImage(named: "icon_funny"))
    ]

    var rowHeightEstimateCache = [String:CGFloat]()

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
            self.detailViewController = (controllers.last as! UINavigationController).topViewController as? DetailViewController
        }

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView!.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Top)
            performSegueWithIdentifier("showWhispers", sender: self)
        }

        navigationItem.leftBarButtonItem = nil
        let titleLogo = UIImage(named: "card_logo")
        navigationItem.titleView = UIImageView(image: titleLogo)

        let newWhisperButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "didTapNewWhisperButton")
        navigationItem.rightBarButtonItem = newWhisperButton
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showWhispers" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                var section: Section? = nil
                switch indexPath.section {
                case 0:
                    section = sections[indexPath.row].0
                case 1:
                    section = categories[indexPath.row].0
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sections.count
        case 1:
            return categories.count
        case 2:
            return others.count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        switch indexPath.section {
        case 0:
            
            let attributes = [
                NSFontAttributeName : (UIFont) .typiconFontOfSize(28)]
            let sectionName = sections[indexPath.row].0.rawValue as String
                
            var text: NSMutableAttributedString = NSMutableAttributedString(string: (NSString) .typiconStringForIconName(sections[indexPath.row].0.iconFont), attributes: attributes)
            text.appendAttributedString(NSAttributedString(string: " " + sectionName.capitalizedString, attributes: [:]))
        
            cell.textLabel!.attributedText = text

        case 1:
            let categoryName = categories[indexPath.row].0.rawValue as String
            cell.textLabel!.text = categoryName.capitalizedString
        case 2:
            let cellName = others[indexPath.row].0.rawValue as String
            cell.textLabel!.text = cellName.capitalizedString
            cell.hidden = true // Hide the cell until new confession API is figured out
        default:
            break

        }

        cell.textLabel?.textAlignment = NSTextAlignment.Left
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            cell.indentationWidth = 15
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0, 1:
            performSegueWithIdentifier("showWhispers", sender: self)
        case 2:
            performSegueWithIdentifier("showNewConfession", sender: self)
        default:
            assertionFailure("Invalid selection in table")
        }

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
            let label = TTTAttributedLabel(frame: CGRectZero)
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
            let label = TTTAttributedLabel(frame: CGRectZero)
            label.font = UIFont(name: "Avenir-Black", size: 12)
            label.textColor = AppColors.DarkBlue
            label.textAlignment = NSTextAlignment.Center
            label.text = self.tableView(tableView, titleForHeaderInSection: section)
            return label
        default:
            return .None
        }
    }

    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        rowHeightEstimateCache["\(indexPath.section):\(indexPath.row)"] = CGRectGetHeight(cell.frame)
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = rowHeightEstimateCache["\(indexPath.section):\(indexPath.row)"] {
            return height
        } else {
            return UITableViewAutomaticDimension
        }
    }

    func didTapNewWhisperButton() {
        let svc = SFSafariViewController(URL: NSURL(string: "http://nuswhispers.com/mobile_submit")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }

}