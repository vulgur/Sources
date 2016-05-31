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
    var theme = "monokai"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = filename
        
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        downloadSourceCode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Private methods
    private func downloadSourceCode() {
        if let template = htmlTemplateString() {
            let url = NSURL(string: downloadAPI)!
            
            Alamofire.request(.GET, url)
                .responseData(completionHandler: { (response) in
                    if let htmlData = response.data {
                        let dataString = String(data: htmlData, encoding: NSUTF8StringEncoding)!
                        let htmlString = template.stringByReplacingOccurrencesOfString("#code#", withString: dataString)
                            .stringByReplacingOccurrencesOfString("#title#", withString: self.filename)
                            .stringByReplacingOccurrencesOfString("#theme#", withString: self.theme)
                            .stringByReplacingOccurrencesOfString("#font_size#", withString: "\(self.fontSize)")
                        dispatch_async(dispatch_get_main_queue(), {
                            self.webView.loadHTMLString(htmlString, baseURL: NSBundle.mainBundle().bundleURL)
                        })
                    }
                })
        }
    }
    
    private func htmlTemplateString() -> String? {
        let path = NSBundle.mainBundle().URLForResource("template", withExtension: "html")!
        print("HTML path:", path)
        let str: String?
        do {
            str = try String(contentsOfURL: path)
        } catch {
            str = nil
        }
        return str
    }
}

