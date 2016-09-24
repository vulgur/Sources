//
//  RepoViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/12.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
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
    fileprivate func setupWebView() {
        webView.delegate = self
//        webView.scalesPageToFit = true
        let url = URL(string: String(format: "https://api.github.com/repos/%@/%@/readme", viewModel.owner.value.loginName!, viewModel.name.value))!
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/vnd.github.VERSION.html", forHTTPHeaderField: "Accept")
        
        EZLoadingActivity.showOnView("loading README", disableUI: false, view: webView)
        Alamofire.request(request as! URLRequestConvertible).responseString { (response) in
            if let readmeStr = response.result.value {
                if let readmeTemplate = self.readmeTemplateString() {
                    let htmlStr = readmeTemplate.replacingOccurrences(of: "#code#", with: readmeStr)
                    self.webView.loadHTMLString(htmlStr, baseURL: Bundle.main.bundleURL)
                }
            }
        }
        
    }
    
    fileprivate func setupUI() {
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
    
    fileprivate func bindViewModel() {
        viewModel.name.bind(to: repoNameLabel.bnd_text)
        viewModel.name.bind(to: repoNameLabel.bnd_text)
        viewModel.ownerName.bind(to: navigationItem.bnd_title)
        viewModel.description.bind(to: repoDescriptionLabel.bnd_text)
        viewModel.stars.map {"\($0)"}.bind(to: starsLabel.bnd_text)
        viewModel.forks.map {"\($0)"}.bind(to: forksLabel.bnd_text)
        viewModel.watchers.map {"\($0)"}.bind(to: watchersLabel.bnd_text)
//        viewModel.createdDate.map{ $0.componentsSeparatedByString("T").first }.bindTo(createdDateLabel.bnd_text)
        viewModel.updatedDate.map{ $0.components(separatedBy: "T").first }.bind(to:updatedDateLabel.bnd_text)
//        viewModel.size.map {  String(format: "%.2fMB" , Float($0)/1024) }.bindTo(sizeLabel.bnd_text)
        viewModel.language.bind(to: languageLabel.bnd_text)
        
        avatarImageView.kf_setImage(with: URL(string: viewModel.avatarImageURLString.value), placeholder: UIImage(named: "user_avatar"))
        
        RecentsManager.sharedManager.currentRepoName = viewModel.name.value
        RecentsManager.sharedManager.currentOwnerName = viewModel.ownerName.value
    }
    
    fileprivate func readmeTemplateString() -> String? {
        let path = Bundle.main.url(forResource: "readme", withExtension: "html")!
        let str: String?
        do {
            str = try String(contentsOf: path)
        } catch {
            str = nil
        }
        return str
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFileList" {
            let fileListVC = segue.destination as! FileListViewController
            fileListVC.apiURLString = "https://api.github.com/repos/" + viewModel.fullName.value + "/contents"
            fileListVC.pathTitle = "/"
//            EZLoadingActivity.hide()
        }
        else if segue.identifier == "ShowBranchList" {
            let branchListVC = segue.destination as! BranchListViewController
            branchListVC.ownerName = viewModel.ownerName.value
            branchListVC.repoName = viewModel.name.value
        }
    }
    

}

extension RepoViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {

        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fitSize = webView.sizeThatFits(CGSize.zero)
        frame.size = fitSize
        webView.frame = frame
        self.view.layoutIfNeeded()
        
        let webViewHeight = frame.size.height
//        let webViewHeight = (webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight;")! as NSString).floatValue
//        let webViewHeight = (webView.stringByEvaluatingJavaScriptFromString("document.body.scrollHeight")! as NSString).floatValue
//        let webViewHeight = (webView.stringByEvaluatingJavaScriptFromString("document.height")! as NSString).floatValue
        let contentViewHeight = CGFloat(webViewHeight) + webView.frame.origin.y
        self.contentView.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: contentViewHeight))
        self.view.layoutIfNeeded()
        EZLoadingActivity.hide()
    }
}
