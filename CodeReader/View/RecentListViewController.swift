//
//  RecentListViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/6/23.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class RecentListViewController: UITableViewController {
    
    let CellIdentifier = "RecentFileCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Recents"

        self.tableView.registerNib(UINib.init(nibName: "RecentFileCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentsManager.sharedManager.recents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! RecentFileCell

        let recent = RecentsManager.sharedManager.recents[indexPath.row]
        cell.fileNameLabel.text = recent.file.name
        cell.ownerRepoLabel.text = recent.ownerName + " / " + recent.repoName

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let recent = RecentsManager.sharedManager.recents[indexPath.row]
        let file = recent.file
        
        let codeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CodeViewController") as! CodeViewController
        codeVC.file = file
        codeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(codeVC, animated: true)
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
