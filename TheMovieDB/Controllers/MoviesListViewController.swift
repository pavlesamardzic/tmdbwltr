//
//  MoviesListViewController.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import UIKit
import Foundation
class MoviesListViewController: UIViewController, AlertDisplayer {
    
    private enum CellIdentifiers {
        static let list = "List"
        static let search = "SearchListCell"
    }
    @IBOutlet weak var tableView: UITableView!
    //var site: String!
    private var searchViewModel: SearchMoviesViewModel?
    private var popularViewModel: PopularMoviesViewModel!
    
    private var shouldShowLoadingCell = false
    private let searchController = UISearchController(searchResultsController: nil)
    private var suggestions: [String]?
    private var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        loadPopularMovies()
    }
    
    func loadPopularMovies() {
        let popularRequest = MovieRequest.init()
        popularViewModel = PopularMoviesViewModel(request: popularRequest, delegate:self)
        popularViewModel.fetchMovies()
    }
    
    func startSearchWith(_ searchString: String) {
        let searchRequest = MovieSearchRequest.from(query: searchString)
        searchViewModel = SearchMoviesViewModel(request: searchRequest, delegate: self)
        searchViewModel?.fetchMovies()
    }
    
    func viewModel() -> MoviesViewModel {
        if let searchViewModel = searchViewModel, searchViewModel.currentCount > 0 {
            return searchViewModel
        }
        return popularViewModel
    }
    
    func setupComponents() {
        
        // setup search controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        suggestions = UserDefaults.standard.array(forKey: "Suggestions") as? [String]
    }
}

extension MoviesListViewController: SearchViewModelDelegate {
    func onSearchFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        if (searchActive) {
            return
        }
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            //indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        // 2
    
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onSearchFetchFailed(with reason: String) {
        if (searchActive) {
            return
        }
        
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

extension MoviesListViewController: PopularMoviesViewModelDelegate {
    func onPopularFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        if (searchActive) {
            return
        }
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            //indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        // 2
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onPopularFetchFailed(with reason: String) {
        if (searchActive) {
            return
        }
        
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        if searchActive {
            return suggestions?.count ?? 0;
        } else {
            return viewModel().totalCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.search, for: indexPath)
            cell.textLabel?.text = suggestions?[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list, for: indexPath) as! MovieTableViewCell
            if isLoadingCell(for: indexPath) {
                cell.configure(with: .none)
            } else {
                cell.configure(with: viewModel().movie(at: indexPath.row))
            }
            return cell
        }
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            setSearchActive(false)
            startSearchWith(suggestions![indexPath.row])
        }
    }
}

extension MoviesListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel().fetchMovies()
        }
    }
}

private extension MoviesListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel().currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setSearchActive(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        setSearchActive(false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let existingSuggestions = UserDefaults.standard.array(forKey: "Suggestions")
        var newSuggestions: [String] = []
        
        newSuggestions.insert(searchBar.text!, at: 0)
        if let existingSuggestions = existingSuggestions {
            newSuggestions.append(contentsOf: existingSuggestions as! [String])
        }
        if (newSuggestions.count > 10) {
            newSuggestions.removeLast()
        }
        UserDefaults.standard.set(newSuggestions, forKey: "Suggestions")
        UserDefaults.standard.synchronize()
        suggestions = newSuggestions
        setSearchActive(false)
        startSearchWith(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setSearchActive(false)
        viewModel().movies.removeAll()
        tableView.reloadData()
        
        loadPopularMovies()
    }
    
    func setSearchActive(_ active: Bool) {
        searchActive = active
        tableView.reloadData()
    }
}
