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

class CommitListViewController: UITableViewController {
    let CommitCellIdentifier = "CommitCell"
    var commits = [Commit]()
    var apiURLString: String?
    var viewModel = CommitListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Commits"
        
        tableView.register(UINib.init(nibName: "CommitCell", bundle: nil), forCellReuseIdentifier: CommitCellIdentifier)
        tableView.rowHeight = 70
        
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let api = apiURLString {
            fetchFileList(api)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    func bindViewModel() {
    }
    
    func fetchFileList(_ urlString: String) {
        EZLoadingActivity.show("loading files", disableUI: true)
        Alamofire.request(urlString)
            .responseArray(completionHandler: { (response: DataResponse<[Commit]>) in
                if let items = response.result.value {
                    self.commits = items
                    self.tableView.reloadData()
                }
                EZLoadingActivity.hide()
            })
//            .responseJSON { (response) in
//                switch response.result{
//                case .success:
//                    if let items = Mapper<Commit>().mapArray(response.result.value) {
//                        self.commits = items
//                        self.tableView.reloadData()
//                    }
//                case .failure(let error):
//                    print(error)
//                }

//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commits.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommitCellIdentifier, for: indexPath) as! CommitCell

        // Configure the cell...
        let commit = commits[(indexPath as NSIndexPath).row]
        cell.avatarImageView.kf_setImage(with: URL(string: commit.committer!.avatarURLString!)!)
        if let message = commit.commitInfo?.message,
            let committerName = commit.committer?.loginName,
            let dateString = commit.commitInfo?.committer?.dateString,
            let sha = commit.sha {
            
            if let date = dateString.toDateFromISO8601() {
                
                let dateToShow = date.inRegion().toString(style: nil, dateStyle: .medium, timeStyle: nil, relative: true)!
                cell.committerLabel.text = "\(committerName) committed on \(dateToShow)"
            } else {
                cell.committerLabel.text = "\(committerName) committed on \(dateString)"
            }
            cell.messageLabel.text = message
            cell.shaLabel.text = sha.substring(to: sha.characters.index(sha.startIndex, offsetBy: 7))
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
