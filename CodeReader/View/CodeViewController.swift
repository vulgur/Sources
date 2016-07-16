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
    var file: RepoFile!
    var fontSize = 3
    var theme = "default"
    var contentString = ""
    
    @IBOutlet var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = file.name
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.insertSubview(webView, belowSubview: favoriteButton)
        self.theme = NSUserDefaults.standardUserDefaults().stringForKey("default_theme") ?? "default"
        downloadSourceCode()
        
        setFavoriteButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.scrollView.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.scrollView.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Private methods
    private func isFavorite() -> Bool {
        if let lastRecent = RecentsManager.sharedManager.recents.first {
            if RecentsManager.sharedManager.favorites.contains(lastRecent) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    private func setFavoriteButton() {
        if isFavorite() {
            favoriteButton.setBackgroundImage(UIImage(named: "favorite"), forState: .Normal)
            print("Favorite true")
        } else {
            favoriteButton.setBackgroundImage(UIImage(named: "unfavorite"), forState: .Normal)
            print("Favorite false")
        }
    }
    
    private func downloadSourceCode() {
        if let template = htmlTemplateString(), downloadURLString = file.downloadURLString {
            
            let url = NSURL(string: downloadURLString)!
            
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
                                .stringByReplacingOccurrencesOfString("#title#", withString: self.file.name ?? "")
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
                            RecentsManager.sharedManager.recents.removeFirst()
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
                .stringByReplacingOccurrencesOfString("#title#", withString: self.file.name ?? "")
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
    
    @IBAction func toggleFavorite(sender: UIButton) {
        if let lastRecent = RecentsManager.sharedManager.recents.first {
            if isFavorite() {
                UIView.transitionWithView(self.favoriteButton, duration: 0.3, options: [.TransitionCrossDissolve], animations: { 
                    self.favoriteButton.setImage(UIImage(named: "unfavorite"), forState: .Normal)
                    }, completion: nil)
                RecentsManager.sharedManager.removeFavorite(lastRecent)
            } else {
                UIView.transitionWithView(self.favoriteButton, duration: 0.3, options: [.TransitionCrossDissolve], animations: { 
                    self.favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
                    }, completion: nil)
                RecentsManager.sharedManager.addFavorite(lastRecent)
            }
        }
    }
}

extension CodeViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.webView.scrollView == scrollView {
            UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseIn], animations: { 
                self.favoriteButton.alpha = 0
                }, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.webView.scrollView == scrollView {
            let time: NSTimeInterval = 1
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue(), {
                UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseOut], animations: {
                    self.favoriteButton.alpha = 1
                    }, completion: nil)
            })
        }
    }
}

