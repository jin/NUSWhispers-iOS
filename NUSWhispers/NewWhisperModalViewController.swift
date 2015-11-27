//
//  NewWhisperModalViewController.swift
//  NUSWhispers
//
//  Created by jin on 12/7/15.
//  Copyright (c) 2015 crypt. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewWhisperModalViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var newWhisperWebView: UIWebView!

    let whispersURL = NSURL(string: "http://nuswhispers.com/mobile_submit")!

    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.dismiss()

        newWhisperWebView.keyboardDisplayRequiresUserAction = false

        loadNewWhisperPage()
    }

    private func loadNewWhisperPage() {
        newWhisperWebView.delegate = self
        let whisperSiteRequest = NSURLRequest(URL: whispersURL)
        newWhisperWebView.loadRequest(whisperSiteRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    }

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL == whispersURL {
//            SVProgressHUD.showWithStatus("Loading..")
        }
        return true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
//        SVProgressHUD.dismiss()
    }

    @IBAction func didTapCloseModalButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
