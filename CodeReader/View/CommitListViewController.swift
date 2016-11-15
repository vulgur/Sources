//
//  CommitListViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/9/4.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher
import SwiftDate
import EZLoadingActivity
import Crashlytics

class CommitListViewController: BaseTableViewController {
    let CommitCellIdentifier = "CommitCell"
    var viewModel: CommitListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Commits"
        
        tableView.register(UINib.init(nibName: "CommitCell", bundle: nil), forCellReuseIdentifier: CommitCellIdentifier)
        tableView.rowHeight = 70
        
        Answers.logCustomEvent(withName: "Show Commit List", customAttributes: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    func bindViewModel() {
        viewModel.page = 1
        viewModel.commits.asDriver()
            .drive(tableView.rx.items(cellIdentifier: CommitCellIdentifier, cellType: CommitCell.self)) { (row, commit, cell) in
                
                if let avatarURLString = commit.committer?.avatarURLString,
                    let avatarURL = URL(string: avatarURLString) {
                    cell.avatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(named: "user_avatar"))
                } else {
                    cell.avatarImageView.image = UIImage(named: "user_avatar")
                }
                
                if let message = commit.commitInfo?.message,
//                    let committerName = commit.committer?.loginName,
                    let dateString = commit.commitInfo?.committer?.dateString,
                    let sha = commit.sha {
                    
                    if let date = try? DateInRegion(string: dateString, format: .iso8601(options: .withInternetDateTime)) {
                        let dateToShow = date.string(dateStyle: .medium, timeStyle: .none)
                        cell.committerLabel.text = "\(dateToShow)"
                    } else {
                        cell.committerLabel.text = "\(dateString)"
                    }
                    cell.messageLabel.text = message
                    cell.shaLabel.text = sha.substring(to: sha.characters.index(sha.startIndex, offsetBy: 7))
                }
        }.addDisposableTo(disposeBag)
        
        viewModel.loadCommitList().subscribe(onNext: {[unowned self] (commits) in
            self.viewModel.commits.value = commits
            }
        ).addDisposableTo(disposeBag)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.commits.value.count
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowCommitFileList", sender: indexPath)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCommitFileList" {
            if let destinationVC = segue.destination as? CommitFileListViewController,
                let indexPath = sender as? IndexPath{
                let commit = self.viewModel.commits.value[indexPath.row]
                destinationVC.viewModel = CommitFileListViewModel(apiURLString: commit.URLString!)
            }
        }
    }
    
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height)
        if (offset >= 0 && offset < 10) {
            let loadMore = viewModel.loadCommitList().asDriver(onErrorJustReturn: [])
            _ = loadMore.asObservable().subscribe(onNext: { (more) in
                self.viewModel.commits.value.append(contentsOf: more)
            })
        }
    }
}
