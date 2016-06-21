//
//  CodeViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/31.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class CodeViewController: UIViewController {
    
    var webView: WKWebView!
    var downloadAPI: String!
    var filename: String!
    var fontSize = 3
    var theme = "default"
    var contentString = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = filename
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)
        self.theme = NSUserDefaults.standardUserDefaults().stringForKey("default_theme") ?? "default"
        downloadSourceCode()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Private methods
    private func downloadSourceCode() {
        if let template = htmlTemplateString() {
            let url = NSURL(string: downloadAPI)!
            
            EZLoadingActivity.show("loading source", disableUI: true)
            
            Alamofire.request(.GET, url)
                .responseData(completionHandler: { (response) in
                    EZLoadingActivity.hide()
                    if let htmlData = response.data {
                        if let dataString = String(data: htmlData, encoding: NSUTF8StringEncoding) {
                            let escapeString = dataString.stringByReplacingOccurrencesOfString("<", withString: "&lt;")
                                .stringByReplacingOccurrencesOfString(">", withString: "&gt;")
                            self.contentString = escapeString
                            let htmlString = template.stringByReplacingOccurrencesOfString("#code#", withString: escapeString)
                                .stringByReplacingOccurrencesOfString("#title#", withString: self.filename)
                                .stringByReplacingOccurrencesOfString("#theme#", withString: self.theme)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.webView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle().bundleURL)
                            })
                        } else {
                            // not a text file, show alert and then pop back
                            
                            let alertController = UIAlertController(title: "", message: "This file is not a source code file", preferredStyle: .Alert)
                            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (_) in
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                            alertController.addAction(alertAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                })
        }
    }
    
    private func htmlTemplateString() -> String? {
        let path = NSBundle.mainBundle().URLForResource("template", withExtension: "html")!
        let str: String?
        do {
            str = try String(contentsOfURL: path)
        } catch {
            str = nil
        }
        return str
    }
    
    private func reloadWebView(contentString: String, theme: String) {
        self.theme = theme
        if let template = htmlTemplateString() {
            let htmlString = template.stringByReplacingOccurrencesOfString("#code#", withString: contentString)
                .stringByReplacingOccurrencesOfString("#title#", withString: self.filename)
                .stringByReplacingOccurrencesOfString("#theme#", withString: theme)
            dispatch_async(dispatch_get_main_queue(), {
//                self.webView.loadHTMLString("", baseURL: nil)
                self.webView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle().bundleURL)
            })
 
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.webView.frame = CGRect(origin: CGPointZero, size: size)
    }
    
    @IBAction func changeTheme(segue: UIStoryboardSegue) {
        if let themeListVC = segue.sourceViewController as? ThemeListViewController {
//            print(themeListVC.selectedTheme)
            if let selectedTheme = themeListVC.selectedTheme?.name {
                reloadWebView(contentString, theme: selectedTheme)
            }
        }
    }
}

