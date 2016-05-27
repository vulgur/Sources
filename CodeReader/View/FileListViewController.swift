//
//  FileListViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/27.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class FileListViewController: UITableViewController {
    
    var fileList = [RepoFile]()
    var apiURLString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib.init(nibName: "FileCell", bundle: nil), forCellReuseIdentifier: "FileCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let path = apiURLString {
            fetchFileList(path)
        }
    }
    
    func fetchFileList(path: String) {
        print("File list:", path)
        Alamofire.request(.GET, path)
            .responseJSON { (response) in
                switch response.result{
                case .Success:
                    if let items = Mapper<RepoFile>().mapArray(response.result.value) {
                        self.fileList = items
                        self.tableView.reloadData()
                    }
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileCell", forIndexPath: indexPath) as! FileCell
        let file = fileList[indexPath.row]
        if file.type == "dir" {
            cell.filenameLabel.textColor = UIColor(red: 51/255, green: 98/255, blue: 178/255, alpha: 1)
        }
        cell.filenameLabel.text = file.name
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
}
