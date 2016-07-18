//
//  HistoryViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/6/23.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    let CellIdentifier = "RecentFileCell"
    var recentList = [Recent]()

    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "History"

        self.tableView.registerNib(UINib.init(nibName: "RecentFileCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
        self.tableView.rowHeight = 70
        configSegmentedControl()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configSegmentedControl() {
        self.segmentedControl.addTarget(self, action: #selector(HistoryViewController.segmentChanged(_:)), forControlEvents: .ValueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.recentList = RecentsManager.sharedManager.recents
    }

    @objc private func segmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            recentList = RecentsManager.sharedManager.recents
        case 1:
            if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
                recentList = RecentsManager.sharedManager.favorites
            } else {
                let alertController = UIAlertController(title: "", message: "Buy me a coffee to unlock favorites", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(alertAction)
                self.presentViewController(alertController, animated: true, completion: {
                    self.segmentedControl.selectedSegmentIndex = 0
                    self.segmentedControl.didChangeValueForKey("selectedSegmentIndex")
                })
            }
        default:
            recentList = RecentsManager.sharedManager.recents
        }
        self.tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let recent = RecentsManager.sharedManager.recents[indexPath.row]
        let file = recent.file
        
        let codeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CodeViewController") as! CodeViewController
        codeVC.file = file
        codeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(codeVC, animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! RecentFileCell
        
        let recent = recentList[indexPath.row]
        cell.fileNameLabel.text = recent.file.name
        cell.ownerRepoLabel.text = recent.ownerName + " / " + recent.repoName
        
        return cell
    }
}
