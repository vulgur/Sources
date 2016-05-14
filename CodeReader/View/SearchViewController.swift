//
//  SearchViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
//import AlamofireObjectMapper
import ObjectMapper
import Kingfisher

class SearchViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var viewModel = SearchRepoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib.init(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: "repo")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75.0
        
        segmentedControl.addTarget(self, action: #selector(self.searchSortChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    // MARK: Actions
    func searchSortChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.sortType = .Best
        case 1:
            viewModel.sortType = .Stars
        case 2:
            viewModel.sortType = .Forks
        case 3:
            viewModel.sortType = .Updated
        default:
            viewModel.sortType = .Best
        }
        
        viewModel.searchRepos {
            self.tableView.reloadDataWithAutoSizingCells()
        }
    }
    
    // MARK: Private methods

}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowRepoDetail", sender: nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == viewModel.repos.count - 3 {
            viewModel.currentPage += 1
            
            viewModel.searchRepos {
                self.tableView.reloadDataWithAutoSizingCells()
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repo", forIndexPath: indexPath) as! SearchRepoCell
        let repo = viewModel.repos[indexPath.row]
        cell.repoNameLabel.text = repo.fullName
        cell.repoDescriptionLabel.text = repo.description
        cell.repoStarsLabel.text = "stars: \(repo.starsCount!)"
        cell.repoForksLabel.text = "forks: \(repo.forksCount!)"
        cell.ownerAvatarImageView.kf_setImageWithURL(NSURL(string: repo.owner!.avatarURLString!)!)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Search for: ", searchBar.text!)
        searchBar.endEditing(true)
        
        viewModel.keyword = searchBar.text!
        
        viewModel.searchRepos{
            self.tableView.reloadDataWithAutoSizingCells()
            let topIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(topIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
}
