//
//  SearchViewModel.swift
//  TheMovieDB
//
//  Created by Pavle on 20.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate: class {
    func onSearchFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onSearchFetchFailed(with reason: String)
}

final class SearchMoviesViewModel: MoviesViewModel {
    private weak var delegate: SearchViewModelDelegate?
    
    let request: MovieSearchRequest
    
    init(request: MovieSearchRequest, delegate: SearchViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    override func fetchMovies() {
        // 1
        guard !isFetchInProgress else {
            return
        }
        
        // 2
        isFetchInProgress = true
        
        client.fetchSearchMovies(with: request, page: currentPage) { result in
            switch result {
            // 3
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onSearchFetchFailed(with: error.reason)
                }
            // 4
            case .success(let response):
                DispatchQueue.main.async {
                    // 1
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    // 2
                    self.total = response.totalMovies
                    self.movies.append(contentsOf: response.movies)
                    
                    // 3
                    if response.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.movies)
                        self.delegate?.onSearchFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onSearchFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
}
