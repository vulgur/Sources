//
//  SearchViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Kingfisher

class SearchViewController: UIViewController {
    
    enum SortType: String {
        case Best = ""
        case Stars = "stars"
        case Forks = "forks"
        case Updated = "updated"
    }

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var repos = [Repo]()
    private var currentPage = 1
    private var totalPage = 0
    private var sortType = SortType.Best
    private var currentKeywords = ""
    
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
            sortType = .Best
        case 1:
            sortType = .Stars
        case 2:
            sortType = .Forks
        case 3:
            sortType = .Updated
        default:
            sortType = .Best
        }
        
        searchRepos(currentKeywords, withSortType: sortType)
    }
    
    // MARK: Private methods
    private func searchRepos(keyword: String,  withSortType sortType: SortType = .Best) {
        let urlParams = [
            "q": keyword,
            "sort" : sortType.rawValue
            ]
        
        // Fetch Request
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: urlParams)
            .responseObject { (response: Response<SearchRepoResponse, NSError>) in
                let value = response.result.value
                if let items = value?.items {
                    self.repos = items
                    self.tableView.reloadDataWithAutoSizingCells()
                    print("Search successfully (keyword: \(keyword) sort: \(sortType.rawValue)")
                }
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowRepoDetail", sender: nil)
//        let repoVC = RepoViewController()
//        navigationController?.pushViewController(repoVC, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == repos.count - 3 {
            currentPage += 1
            let urlParams = [
                "q": searchBar.text!,
                "sort":"stars",
                "order":"desc",
                "page": "\(currentPage)"
                ]
            
            // Fetch Request
            Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: urlParams)
                .responseObject { (response: Response<SearchRepoResponse, NSError>) in
                    if let error = response.result.error {
                        print(error)
                    }
                    let headerLink = response.response?.allHeaderFields["Link"] as! String
                    if !headerLink.containsString("rel=\"next\"") {
                        print("No more data")
                        return
                    }
                    let value = response.result.value
                    if let items = value?.items {
                        self.repos.appendContentsOf(items)
                        self.tableView.reloadData()
                        print("Load more successfully")
                    }
            }
 
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("repo", forIndexPath: indexPath) as! SearchRepoCell
        let repo = repos[indexPath.row]
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
        
        currentKeywords = searchBar.text!
        
        searchRepos(currentKeywords, withSortType: sortType)
    }
}
