//
//  BranchListViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/9/6.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import SwiftDate
import RxSwift
import RxCocoa

class BranchListViewController: BaseTableViewController {
    var viewModel: BranchListViewModel!
    var ownerName: String!
    var repoName: String!

    let BranchCellIdentifier = "BranchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Branches"
        
        tableView.register(UINib.init(nibName: "BranchCell", bundle: nil), forCellReuseIdentifier: BranchCellIdentifier)
        tableView.rowHeight = 70
        
        bindViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        viewModel = BranchListViewModel(ownerName: ownerName, repoName: repoName)
        viewModel.dataSource.configureCell = { [unowned self] dataSource, tableView, indexPath, branch in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.BranchCellIdentifier, for: indexPath) as! BranchCell
            cell.branchLabel.text = branch.name
            cell.branchLabel.layer.cornerRadius = 3
            cell.branchLabel.layer.masksToBounds = true
            cell.branchLabel.insets = UIEdgeInsetsMake(0, 5, 0, 5)
            cell.updateInfoLabel.alpha = 0
            cell.messageLabel.alpha = 0
            self.viewModel.loadLatestCommit(urlString: branch.latestCommitURLString!).subscribe(onNext: { (commit) in
                
                if let dateString = commit.commitInfo?.committer?.dateString {
                    let date = try! DateInRegion(string: dateString, format: .iso8601(options: .withInternetDateTime))
                    let (colloquial, _) = try! date.colloquialSinceNow()
                    cell.updateInfoLabel.text = colloquial
                    cell.messageLabel.text = commit.commitInfo?.message
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.updateInfoLabel.alpha = 1
                        cell.messageLabel.alpha = 1
                    })
                }
            }).addDisposableTo(self.disposeBag)
            return cell
        }
        
        viewModel.loadBranches().map { (branches) -> [BranchSection] in
            return branches.map {
                BranchSection(items: [$0])
            }
        }.bindTo(tableView.rx.items(dataSource: viewModel.dataSource))
        .addDisposableTo(disposeBag)
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.info("Select index path:\(indexPath.section, indexPath.row)")
        if let branch = try! viewModel.dataSource.model(at: indexPath) as? Branch {
            performSegue(withIdentifier: "ShowCommitList", sender: branch.name)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCommitList" {
           
            if let branchName = sender as? String,
                let commitListVC = segue.destination as? CommitListViewController{
                let url = "https://api.github.com/repos/\(viewModel.ownerName!)/\(viewModel.repoName!)/commits?sha=\(branchName)"
                let commitListViewModel = CommitListViewModel(apiURLString: url)
                commitListVC.viewModel = commitListViewModel
            }
        }
    }

}
