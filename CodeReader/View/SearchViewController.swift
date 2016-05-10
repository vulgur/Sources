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
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        
//    }
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
        
        let urlParams = [
            "q": searchBar.text!,
            "sort":"stars",
            "order":"desc",
            ]
        
        // Fetch Request
        Alamofire.request(.GET, "https://api.github.com/search/repositories", parameters: urlParams)
            .responseObject { (response: Response<SearchRepoResponse, NSError>) in
                let value = response.result.value
                if let items = value?.items {
                    self.repos = items
                    self.tableView.reloadData()
                    print("Search successfully")
                }
        }
//        .responseJSON { (response) in
//            if let JSON = response.result.value, items = JSON["items"] {
//                print("items:", JSON["items"])
//                let results = Mapper<Repo>().mapArray(items)
//                print(results!.count)
//                print(results!.first)
//            }
//        }

    }
}
