//
//  BranchListViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/9/6.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import SwiftDate

class BranchListViewController: UITableViewController {
    var viewModel: BranchListViewModel!
    var ownerName: String!
    var repoName: String!

    let BranchCellIdentifier = "BranchCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Branches"
        
        tableView.register(UINib.init(nibName: "BranchCell", bundle: nil), forCellReuseIdentifier: BranchCellIdentifier)
        tableView.rowHeight = 70
        
        viewModel = BranchListViewModel(ownerName: ownerName, repoName: repoName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadBranches(completion:  {
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.branches.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BranchCellIdentifier, for: indexPath) as! BranchCell

        let branch = viewModel.branches[(indexPath as NSIndexPath).section]
        // Configure the cell...
        cell.branchLabel.text = branch.name
        cell.branchLabel.layer.cornerRadius = 3
        cell.branchLabel.layer.masksToBounds = true
        cell.branchLabel.insets = UIEdgeInsetsMake(0, 5, 0, 5)
        
        viewModel.loadLatestCommit(branch.latestCommitURLString!, completion: { (commit) in
            if let dateString = commit.commitInfo?.committer?.dateString {
                if let date = dateString.toDateFromISO8601() {
                    let localRegion = Region(calendarName: .autoUpdatingCurrent, timeZoneName: nil, localeName: nil)
                    cell.updateLabel.alpha = 0
                    
                    let updateString = date.toString(style: .full)
//                        date.toNaturalString(Date(), inRegion: localRegion, style: FormatterStyle.init(style: .full, units: nil, max: 1))!
//                        + " ago by " + (commit.committer?.loginName)!
                    cell.updateLabel.text = updateString
                    UIView.animate(withDuration: 0.3, animations: {
                        cell.updateLabel.alpha = 1
                    })
                }
            }
        })

        return cell
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let branch = viewModel.branches[(indexPath as NSIndexPath).section]
        performSegue(withIdentifier: "ShowCommitList", sender: branch.name)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCommitList" {
            let commitListVC = segue.destination as! CommitListViewController
            if let branchName = sender as? String {
                let url = "https://api.github.com/repos/\(viewModel.ownerName)/\(viewModel.repoName)/commits?sha=\(branchName)"
                commitListVC.apiURLString = url
            }
        }
    }

}
