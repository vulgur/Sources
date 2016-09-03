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

class CommitListViewController: UITableViewController {
    let CommitCellIdentifier = "CommitCell"
    var commits = [Commit]()
    var apiURLString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Commits"
        
        tableView.registerNib(UINib.init(nibName: "CommitCell", bundle: nil), forCellReuseIdentifier: CommitCellIdentifier)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let api = apiURLString {
            fetchFileList(api)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFileList(urlString: String) {
        EZLoadingActivity.show("loading files", disableUI: true)
        Alamofire.request(.GET, urlString)
            .responseJSON { (response) in
                switch response.result{
                case .Success:
                    if let items = Mapper<Commit>().mapArray(response.result.value) {
                        self.commits = items
                        self.tableView.reloadData()
                    }
                case .Failure(let error):
                    print(error)
                }
                EZLoadingActivity.hide()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commits.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CommitCellIdentifier, forIndexPath: indexPath) as! CommitCell

        // Configure the cell...
        let commit = commits[indexPath.row]
        cell.avatarImageView.kf_setImageWithURL(NSURL(string: commit.committer!.avatarURLString!)!)
        if let message = commit.message, committerName = commit.committerName, date = commit.date, sha = commit.sha {
            cell.messageLabel.text = message
            cell.committerLabel.text = "\(committerName) committed on \(date)"
            cell.shaLabel.text = sha.substringToIndex(sha.startIndex.advancedBy(5))
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
