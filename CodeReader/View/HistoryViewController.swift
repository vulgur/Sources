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

        self.tableView.register(UINib.init(nibName: "RecentFileCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
        self.tableView.rowHeight = 70
        configSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configSegmentedControl() {
        self.segmentedControl.addTarget(self, action: #selector(HistoryViewController.segmentChanged(_:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        self.recentList = RecentsManager.sharedManager.recents
    }

    @objc fileprivate func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            recentList = RecentsManager.sharedManager.recents
        case 1:
            if DonationProduct.store.isProductPurchased(DonationProduct.BuyMeACoffee) {
                recentList = RecentsManager.sharedManager.favorites
            } else {
                let alertController = UIAlertController(title: "", message: "Buy me a coffee to unlock favorites", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: {
                    self.segmentedControl.selectedSegmentIndex = 0
                    self.segmentedControl.didChangeValue(forKey: "selectedSegmentIndex")
                })
            }
        default:
            recentList = RecentsManager.sharedManager.recents
        }
        self.tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recent = recentList[(indexPath as NSIndexPath).row]
        let file = recent.file
        
        let codeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CodeViewController") as! CodeViewController
        codeVC.file = file
        codeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(codeVC, animated: true)
    }
}

extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! RecentFileCell
        
        let recent = recentList[(indexPath as NSIndexPath).row]
        cell.fileNameLabel.text = recent.file.name
        cell.ownerRepoLabel.text = recent.ownerName + " / " + recent.repoName
        
        return cell
    }
}
