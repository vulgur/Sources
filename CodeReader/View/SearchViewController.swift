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

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    private var repos = [Repo]()
    private var currentPage = 1
    private var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib.init(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: "repo")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75.0
    }
}

extension SearchViewController: UITableViewDelegate {
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
        cell.repoNameLabel.text = repo.name
        cell.repoDescriptionLabel.text = repo.description
        cell.ownerNameLabel.text = repo.owner?.name
        cell.repoStarsLabel.text = "\(repo.starsCount!)"
        cell.repoForksLabel.text = "\(repo.forksCount!)"
        cell.ownerAvatarImageView.kf_setImageWithURL(NSURL(string: repo.owner!.avatarURLString!)!)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Search for: ", searchBar.text)
        searchBar.endEditing(true)
        
        let urlParams = [
            "q": searchBar.text!,
            ]
        
        // Fetch Request
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: urlParams)
            .responseObject { (response: Response<SearchRepoResponse, NSError>) in
                let value = response.result.value
                if let items = value?.items {
                    self.repos = items
                    self.tableView.reloadDataWithAutoSizingCells()
                    print("Search successfully")
                }
        }
    }
}
