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
    var errorHandler: (String) -> () = {_ in}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib.init(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: "repo")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75.0
        
        segmentedControl.addTarget(self, action: #selector(self.searchSortChanged(_:)), forControlEvents: .ValueChanged)
        errorHandler =  { [unowned self] msg in
            EZLoadingActivity.hide()
            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
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
        
        viewModel.searchRepos(completion: { 
            self.tableView.reloadDataWithAutoSizingCells()
        }, errorHandler: self.errorHandler)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowRepoDetail" {
            if let repoViewModel = sender {
                let destVC = segue.destinationViewController as! RepoViewController
                destVC.viewModel = repoViewModel as! RepoViewModel
            }
        }
    }
    // MARK: Private methods

}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = viewModel.repos[indexPath.row]
        let repoViewModel = RepoViewModel(repo: repo)
        performSegueWithIdentifier("ShowRepoDetail", sender: repoViewModel)
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

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height)
        if (offset >= 0 && offset < 10) {
            EZLoadingActivity.show("Loading more...", disableUI: true)
            viewModel.loadMore(completion:{
                self.tableView.reloadDataWithAutoSizingCells()
                EZLoadingActivity.hide()
                }, errorHandler: self.errorHandler)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Search for: ", searchBar.text!)
        searchBar.endEditing(true)
        
        viewModel.keyword = searchBar.text!
        
        EZLoadingActivity.show("Searching...", disableUI: true)
        
        viewModel.searchRepos(completion: {
            self.tableView.reloadDataWithAutoSizingCells()
            EZLoadingActivity.hide()
            }, errorHandler: self.errorHandler)
    }
}
