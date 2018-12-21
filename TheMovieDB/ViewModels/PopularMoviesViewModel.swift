//
//  MoviesViewModel.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

protocol PopularMoviesViewModelDelegate: class {
    func onPopularFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onPopularFetchFailed(with reason: String)
}

final class PopularMoviesViewModel: MoviesViewModel {
    private weak var delegate: PopularMoviesViewModelDelegate?
    
    
    let request: MovieRequest
    
    init(request: MovieRequest, delegate: PopularMoviesViewModelDelegate) {
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
        
        client.fetchMovies(with: request, page: currentPage) { result in
            switch result {
            // 3
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onPopularFetchFailed(with: error.reason)
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
                        self.delegate?.onPopularFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onPopularFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
}
