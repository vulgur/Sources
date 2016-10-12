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
import EZLoadingActivity

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
        self.theme = UserDefaults.standard.string(forKey: "default_theme") ?? "default"
        downloadSourceCode()
        
        favoriteButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.scrollView.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Private methods
    fileprivate func isFavorite() -> Bool {
        for item in RecentsManager.sharedManager.favorites {
            if item.file == self.file {
                return true
            }
        }
        return false
    }
    
    fileprivate func setFavoriteButton() {
        favoriteButton.isHidden = false
        if isFavorite() {
            favoriteButton.setImage(UIImage(named: "favorite"), for: UIControlState())
        } else {
            favoriteButton.setImage(UIImage(named: "unfavorite"), for: UIControlState())
        }
    }
    
    fileprivate func downloadSourceCode() {
        if let template = htmlTemplateString(), let downloadURLString = file.downloadURLString {
            
            let url = URL(string: downloadURLString)!
            
            EZLoadingActivity.show("loading source", disableUI: true)
            
            Alamofire.request(url)
                .responseData(completionHandler: { (response) in
                    EZLoadingActivity.hide()
                    self.setFavoriteButton()
                    if let htmlData = response.data {
                        if let dataString = String(data: htmlData, encoding: String.Encoding.utf8) {
                            let escapeString = dataString.replacingOccurrences(of: "<", with: "&lt;")
                                .replacingOccurrences(of: ">", with: "&gt;")
                            self.contentString = escapeString
                            let htmlString = template.replacingOccurrences(of: "#code#", with: escapeString)
                                .replacingOccurrences(of: "#title#", with: self.file.name ?? "")
                                .replacingOccurrences(of: "#theme#", with: self.theme)
                            DispatchQueue.main.async(execute: {
                                self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
                            })
                        } else {
                            // not a text file, show alert and then pop back
                            
                            let alertController = UIAlertController(title: "", message: "This file is not a source code file", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_) in
                                _ = self.navigationController?.popViewController(animated: true)
                            })
                            alertController.addAction(alertAction)
                            RecentsManager.sharedManager.recents.removeFirst()
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                })
        }
    }
    
    fileprivate func htmlTemplateString() -> String? {
        let path = Bundle.main.url(forResource: "template", withExtension: "html")!
        let str: String?
        do {
            str = try String(contentsOf: path)
        } catch {
            str = nil
        }
        return str
    }
    
    fileprivate func reloadWebView(_ contentString: String, theme: String) {
        self.theme = theme
        if let template = htmlTemplateString() {
            let htmlString = template.replacingOccurrences(of: "#code#", with: contentString)
                .replacingOccurrences(of: "#title#", with: self.file.name ?? "")
                .replacingOccurrences(of: "#theme#", with: theme)
            DispatchQueue.main.async(execute: {
//                self.webView.loadHTMLString("", baseURL: nil)
                self.webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            })
 
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.webView.frame = CGRect(origin: CGPoint.zero, size: size)
    }
    
    @IBAction func changeTheme(_ segue: UIStoryboardSegue) {
        if let themeListVC = segue.source as? ThemeListViewController {
//            print(themeListVC.selectedTheme)
            if let selectedTheme = themeListVC.selectedTheme?.name {
                reloadWebView(contentString, theme: selectedTheme)
            }
        }
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
            if isFavorite() {
                UIView.transition(with: self.favoriteButton, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                    self.favoriteButton.setImage(UIImage(named: "unfavorite"), for: UIControlState())
                    }, completion: nil)
                RecentsManager.sharedManager.removeFavoriteByFile(self.file)
            } else {
                UIView.transition(with: self.favoriteButton, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                    self.favoriteButton.setImage(UIImage(named: "favorite"), for: UIControlState())
                    }, completion: nil)
                RecentsManager.sharedManager.addFavoriteByFile(self.file)
            }
        } else {
            let alertController = UIAlertController(title: "", message: "Buy me a coffee to add this file to favorites", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension CodeViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.webView.scrollView == scrollView {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: { 
                self.favoriteButton.alpha = 0
                }, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.webView.scrollView == scrollView {
            let time: TimeInterval = 1
            let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    self.favoriteButton.alpha = 1
                    }, completion: nil)
            })
        }
    }
}

