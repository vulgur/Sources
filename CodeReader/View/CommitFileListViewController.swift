//
//  CommitFileListViewController.swift
//  CodeReader
//
//  Created by vulgur on 2016/10/19.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit

class CommitFileListViewController: BaseTableViewController {

    var viewModel: CommitFileListViewModel!
    let CommitFileCellIdentifier = "CommitFileCell"
//    let dataSource = [("CodeReader.xcodeproj/project.pbxproj", 100, 200, 1),
//                      ("CodeReader.xcodeproj/xcuserdata/wangshudao.xcuserdatad/xcschemes/CodeReader.xcscheme", 3, 43, 2),
//                      ("CodeReader/View/CommitListViewController.swift", 2,232, 1),
//                      ("CodeReader/View/RepoViewController.swift", 9323,121, 3),
//                      ("CodeReader/View/BranchCell.xib", 234,1, 2)]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Commit Files"
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
    private func bindViewModel() {
        viewModel.commitFiles.asDriver()
            .drive(tableView.rx.items(cellIdentifier: CommitFileCellIdentifier, cellType: CommitFileCell.self)) { (row, commitFile, cell) in
                if let filename = commitFile.filename {
                    cell.filenameLabel.text = self.shortenFilename(filename: filename)
                }
                if let additions = commitFile.additions {
                    cell.additionsLabel.text = "+\(additions)"
                }
                if let deletions = commitFile.deletions {
                    cell.deletionsLabel.text = "-\(deletions)"
                }
                
                switch commitFile.status! {
                    case "added": cell.statusImageView.image = #imageLiteral(resourceName: "file_addition")
                    case "modified": cell.statusImageView.image = #imageLiteral(resourceName: "file_modification")
                    case "deleted": cell.statusImageView.image = #imageLiteral(resourceName: "file_deletion")
                    default: cell.statusImageView.image = #imageLiteral(resourceName: "file_addition")
                }
            
        }.addDisposableTo(disposeBag)
        
        viewModel.loadCommitFileList().subscribe(onNext: { [unowned self] (commitFiles) in
            self.viewModel.commitFiles.value = commitFiles
        }).addDisposableTo(disposeBag)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.commitFiles.value.count
    }

    
    private func shortenFilename(filename: String) -> String {
        let paths = filename.components(separatedBy: "/")
        if paths.count > 2 {
            return ".../".appending(paths[paths.count-2]).appending("/").appending(paths.last!)
        }
        return filename
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
