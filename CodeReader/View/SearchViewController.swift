//
//  SearchViewController.swift
//  CodeReader
//
//  Created by vulgur on 16/5/10.
//  Copyright © 2016年 MAD. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var maskView: UIView!
    
    let SearchRepoCellIdentifier = "SearchRepoCell"
    
    var viewModel = SearchRepoViewModel()
//    var errorHandler: (String) -> () = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "SearchRepoCell", bundle: nil), forCellReuseIdentifier: SearchRepoCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        // bind 
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.resignFirstResponder()
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
        // bind segmented control
        _ = self.segmentedControl.rx.value
            .bindTo(viewModel.segmentDidSelect)
        
        _ = self.segmentedControl.rx.value.asDriver().drive(onNext: { (_) in
            self.tableView.scrollToRow(at: IndexPath.init(row: NSNotFound, section: 0), at: .top, animated: false)
            })
        // bind search bar
        _ = self.searchBar.rx.searchButtonClicked.subscribe(onNext: { (_) in
            
            self.searchBar.endEditing(true)
            })
        
        _ = self.searchBar.rx.textDidBeginEditing.subscribe(onNext: {
            self.maskView.isHidden = false
            })
        
        _ = self.searchBar.rx.textDidEndEditing.subscribe(onNext: {
            self.maskView.isHidden = true
            })
        
//        _ = self.searchBar.rx.text.orEmpty
//            .asDriver()
//            .throttle(1)
//            .distinctUntilChanged()
//            .flatMapLatest { [unowned self] (keyword) in
//                if keyword.isEmpty {
//                    return .just([])
//                }
//                self.viewModel.searchKeyword.value = keyword
//                return self.viewModel.searchRepos().asDriver(onErrorRecover: { (error) -> SharedSequence<DriverSharingStrategy, [Repo]> in
//                    log.error("EEEEEERROR")
//                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    let alert = UIAlertController(title: "Error", message: "Bad connection", preferredStyle: .alert)
//                    alert.addAction(alertAction)
//                    self.present(alert, animated: true, completion: nil)
//                    return SharedSequence.empty()
//                })
//            }
//            .asObservable()
//            .bindTo(viewModel.repos)
        
        
        viewModel.repos.asDriver()
            .drive(tableView.rx.items(cellIdentifier: SearchRepoCellIdentifier, cellType: SearchRepoCell.self)) { (row, element, cell) in
                cell.repoNameLabel.text = element.fullName
                cell.repoDescriptionLabel.text = element.description
                cell.repoStarsLabel.text = "stars: \(element.starsCount!)"
                cell.repoForksLabel.text = "forks: \(element.forksCount!)"
                cell.ownerAvatarImageView.kf.setImage(with: URL(string: element.owner!.avatarURLString!)!,
                                                      placeholder: UIImage(named: "user_avatar"),
                                                      options: [.transition(ImageTransition.fade(1))])
            
                
        }
        .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset
            .subscribe { _ in
                if self.searchBar.isFirstResponder {
                    _ = self.searchBar.resignFirstResponder()
                }
            }.addDisposableTo(disposeBag)
        
        viewModel.searchInProgress.asObservable().map{!$0}.bindTo(maskView.rx.isHidden).addDisposableTo(disposeBag)

    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = viewModel.repos.value[indexPath.row]
        let repoViewModel = RepoViewModel(repo: repo)
        performSegue(withIdentifier: "ShowRepo", sender: repoViewModel)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repo", for: indexPath) as! SearchRepoCell
        let repo = viewModel.repos.value[(indexPath as NSIndexPath).row]
        cell.repoNameLabel.text = repo.fullName
        cell.repoDescriptionLabel.text = repo.description
        cell.repoStarsLabel.text = "stars: \(repo.starsCount!)"
        cell.repoForksLabel.text = "forks: \(repo.forksCount!)"
        cell.ownerAvatarImageView.kf.setImage(with: URL(string: repo.owner!.avatarURLString!)!,
                                              placeholder: UIImage(named: "user_avatar"),
                                              options: [.transition(ImageTransition.fade(1))])
        return cell
    }
}

extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height)
        if (offset >= 0 && offset < 10 && viewModel.searchInProgress.value == false) {
            let loadMoreResults = viewModel.loadMore().asDriver(onErrorJustReturn: [])
            _ = loadMoreResults.asObservable().subscribe(onNext: { (repos) in
                self.viewModel.repos.value.append(contentsOf: repos)
                })
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchBar.text else { return }
        searchBar.endEditing(true)
        
        viewModel.searchKeyword.value = searchKeyword
        _ = viewModel.searchRepos().bindTo(viewModel.repos).addDisposableTo(disposeBag)
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.searchInProgress.value = true
        return true
    }
}
