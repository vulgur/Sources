//
//  RepoViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/12.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Bond
import Kingfisher
import Alamofire

class RepoViewController: UIViewController {
    
    let descriptionFontSize: CGFloat = 18.0
    let descriptionLabelHeight: CGFloat = 22.0
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var repoNameLabel: UILabel!
    @IBOutlet var repoDescriptionLabel: UILabel!
    
    @IBOutlet var languageLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var watchersLabel: UILabel!
    @IBOutlet var forksLabel: UILabel!
    @IBOutlet var createdDateLabel: UILabel!
    @IBOutlet var updatedDateLabel: UILabel!
    @IBOutlet var downloadButton: UIBarButtonItem!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var sourceButton: UIButton!
    @IBOutlet var commitsButton: UIButton!
    @IBOutlet var webView: UIWebView!
    
    var viewModel: RepoViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
        viewModel.fetchWatchers()
        setupWebView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Private methods
    private func setupWebView() {
        webView.delegate = self
//        webView.scalesPageToFit = true
        let url = NSURL(string: String(format: "https://api.github.com/repos/%@/%@/readme", viewModel.owner.value.loginName!, viewModel.name.value))!
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/vnd.github.VERSION.html", forHTTPHeaderField: "Accept")
        
        EZLoadingActivity.showOnView("loading README", disableUI: false, view: webView)
        Alamofire.request(request).responseString { (response) in
            if let readmeStr = response.result.value {
                if let readmeTemplate = self.readmeTemplateString() {
                    let htmlStr = readmeTemplate.stringByReplacingOccurrencesOfString("#code#", withString: readmeStr)
                    self.webView.loadHTMLString(htmlStr, baseURL: NSBundle.mainBundle().bundleURL)
                }
            }
        }
        
    }
    
    private func setupUI() {
        // Set the text aligment of description label based on string length
//        let contraintSize = CGSize(width: CGFloat.max, height: descriptionLabelHeight)
//        let fontAttribute = [NSFontAttributeName: UIFont.systemFontOfSize(descriptionFontSize)]
//        let stringRect = (viewModel.description.value as NSString).boundingRectWithSize(contraintSize,
//                                                                                            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
//                                                                                            attributes: fontAttribute,
//                                                                                            context: nil)
//        if CGRectGetWidth(stringRect) > CGRectGetWidth(repoDescriptionLabel.frame) {
//            repoDescriptionLabel.textAlignment = .Left
//        } else {
//            repoDescriptionLabel.textAlignment = .Center
//        }
        
//        sourceButton.backgroundColor = UIColor(red: 51/255, green: 98/255, blue: 178/255, alpha: 1)
//        sourceButton.tintColor = UIColor.whiteColor()
//        commitsButton.backgroundColor = UIColor(red: 36/255, green: 55/255, blue: 75/255, alpha: 1)
//        commitsButton.tintColor = UIColor.whiteColor()
        
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.masksToBounds = true
//        avatarImageView.layer.borderColor = UIColor.blackColor().CGColor
//        avatarImageView.layer.borderWidth = 2
    }
    
    private func bindViewModel() {
        
        viewModel.name.bindTo(repoNameLabel.bnd_text)
        viewModel.ownerName.bindTo(navigationItem.bnd_title)
        viewModel.description.bindTo(repoDescriptionLabel.bnd_text)
        viewModel.stars.map {"\($0)"}.bindTo(starsLabel.bnd_text)
        viewModel.forks.map {"\($0)"}.bindTo(forksLabel.bnd_text)
        viewModel.watchers.map {"\($0)"}.bindTo(watchersLabel.bnd_text)
//        viewModel.createdDate.map{ $0.componentsSeparatedByString("T").first }.bindTo(createdDateLabel.bnd_text)
        viewModel.updatedDate.map{ $0.componentsSeparatedByString("T").first }.bindTo(updatedDateLabel.bnd_text)
//        viewModel.size.map {  String(format: "%.2fMB" , Float($0)/1024) }.bindTo(sizeLabel.bnd_text)
        viewModel.language.bindTo(languageLabel.bnd_text)
        
        avatarImageView.kf_setImageWithURL(NSURL(string: viewModel.avatarImageURLString.value)!, placeholderImage: UIImage(named: "user_avatar"))
        
        RecentsManager.sharedManager.currentRepoName = viewModel.name.value
        RecentsManager.sharedManager.currentOwnerName = viewModel.ownerName.value
    }
    
    private func readmeTemplateString() -> String? {
        let path = NSBundle.mainBundle().URLForResource("readme", withExtension: "html")!
        let str: String?
        do {
            str = try String(contentsOfURL: path)
        } catch {
            str = nil
        }
        return str
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFileList" {
            let fileListVC = segue.destinationViewController as! FileListViewController
            fileListVC.apiURLString = "https://api.github.com/repos/" + viewModel.fullName.value + "/contents"
            fileListVC.pathTitle = "/"
//            EZLoadingActivity.hide()
        }
    }
    

}

extension RepoViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {

        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fitSize = webView.sizeThatFits(CGSizeZero)
        frame.size = fitSize
        webView.frame = frame
        self.view.layoutIfNeeded()
        
        let webViewHeight = frame.size.height
//        let webViewHeight = (webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight;")! as NSString).floatValue
//        let webViewHeight = (webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")! as NSString).floatValue
//        let webViewHeight = (webView.stringByEvaluatingJavaScriptFromString("document.height")! as NSString).floatValue
        let contentViewHeight = CGFloat(webViewHeight) + webView.frame.origin.y
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Height, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: contentViewHeight))
        self.view.layoutIfNeeded()
        EZLoadingActivity.hide()
    }
}