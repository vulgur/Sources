//
//  CommitFileListViewController.swift
//  CodeReader
//
//  Created by vulgur on 2016/10/19.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Crashlytics

class CommitFileListViewController: BaseTableViewController {

    var viewModel: CommitFileListViewModel!
    let CommitFileCellIdentifier = "CommitFileCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Commit Files"
        self.tableView.hideEmptyCells()
        Answers.logCustomEvent(withName: "Show Commit File List", customAttributes: nil)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "ShowFileChange", sender: indexPath)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFileChange" {
            if let destinationVC = segue.destination as? FileChangeViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                let file = viewModel.commitFiles.value[indexPath.row]
                destinationVC.patchString = file.patch
                destinationVC.navigationItem.title = file.filename?.fileBaseName
            }
        }
    }
    

}
