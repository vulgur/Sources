//
//  SearchViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var maskView: UIView!
    
    var viewModel = SearchRepoViewModel()
    var errorHandler: (String) -> () = {_ in}
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapToDissmissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        maskView.addGestureRecognizer(tapToDissmissKeyboard)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: "repo")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 75.0
        
        segmentedControl.addTarget(self, action: #selector(self.searchSortChanged(_:)), for: .valueChanged)
        errorHandler =  { [unowned self] msg in
            EZLoadingActivity.hide()
            self.isLoading = false
            let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        
        // bind 
        bindViewModel()
        
    }
    
    
    // MARK: Actions
    func dismissKeyboard() {
        viewModel.searchInProgress.value = false
//        self.searchBar.endEditing(true)
        self.searchBar.resignFirstResponder()
    }
    
    func searchSortChanged(_ sender: UISegmentedControl) {
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
        
        if let keyword = searchBar.text {
            if keyword.characters.count > 0 {
                viewModel.searchKeyword.value = keyword
                EZLoadingActivity.show("searching...", disableUI: true)
                viewModel.searchRepos(completion: { 
                    let topIndexPath = IndexPath(row: NSNotFound, section: 0)
                    self.tableView.scrollToRow(at: topIndexPath, at: UITableViewScrollPosition.top, animated: true)
                    self.tableView.reloadDataWithAutoSizingCells()
                    EZLoadingActivity.hide()
                }, errorHandler: self.errorHandler)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRepo" {
            if let repoViewModel = sender {
                let destVC = segue.destination as! RepoViewController
                destVC.viewModel = repoViewModel as! RepoViewModel
            }
        }
    }
    // MARK: Private methods
    func bindViewModel() {
        
        let searchResults = searchBar.rx.text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { (keyword) -> Observable<[Repo]> in
                if keyword.isEmpty {
                    return .just([])
                }
                
                return self.viewModel.searchRepos(keyword: keyword)
            }
            .observeOn(MainScheduler.instance)
        
        searchResults.subscribe(onNext: { (repos) in
            repos.forEach({ (repo) in
                print(repo.name)
            })
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            
//        viewModel.searchInProgress.map{!$0}.bind(to: maskView.bnd_isHidden)
//    
//        viewModel.searchResults.bind(to: self.tableView) { (dataSource, indexPath, tableView) -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "repo", for: indexPath) as! SearchRepoCell
//            let repo = dataSource[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
//            cell.repoNameLabel.text = repo.fullName
//            cell.repoDescriptionLabel.text = repo.description
//            cell.repoStarsLabel.text = "stars: \(repo.starsCount!)"
//            cell.repoForksLabel.text = "forks: \(repo.forksCount!)"
//            cell.ownerAvatarImageView.kf_setImage(with: URL(string: repo.owner!.avatarURLString!)!,
//                                                  placeholder: UIImage(named: "user_avatar"),
//                                                  options: [.transition(ImageTransition.fade(1))])
//            
//            return cell
//            
//        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = viewModel.searchResults[(indexPath as NSIndexPath).row]
        let repoViewModel = RepoViewModel(repo: repo)
        performSegue(withIdentifier: "ShowRepo", sender: repoViewModel)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repo", for: indexPath) as! SearchRepoCell
        let repo = viewModel.searchResults[(indexPath as NSIndexPath).row]
        cell.repoNameLabel.text = repo.fullName
        cell.repoDescriptionLabel.text = repo.description
        cell.repoStarsLabel.text = "stars: \(repo.starsCount!)"
        cell.repoForksLabel.text = "forks: \(repo.forksCount!)"
        cell.ownerAvatarImageView.kf_setImage(with: URL(string: repo.owner!.avatarURLString!)!,
                                              placeholder: UIImage(named: "user_avatar"),
                                              options: [.transition(ImageTransition.fade(1))])
        return cell
    }
}

extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height)
        if (offset >= 0 && offset < 10 && isLoading == false) {
            isLoading = true
            viewModel.loadMore(completion:{
                self.tableView.reloadDataWithAutoSizingCells()
                self.isLoading = false
                }, errorHandler: self.errorHandler)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        viewModel.searchKeyword.value = searchBar.text!
        
        EZLoadingActivity.show("searching...", disableUI: true)
        
        viewModel.searchRepos(completion: {
            self.tableView.reloadDataWithAutoSizingCells()
            EZLoadingActivity.hide()
            }, errorHandler: self.errorHandler)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.searchInProgress.value = true
        return true
    }
}
