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
    
    func onSearchFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onSearchFetchFailed(with reason: String)
}

final class PopularMoviesViewModel: MoviesViewModel {
    private weak var delegate: PopularMoviesViewModelDelegate?
    
    let request: MovieRequest
    var isSearchActive = false
    var queri: String = ""
    
    init(request: MovieRequest, delegate: PopularMoviesViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    override func searchMovies(request: MovieSearchRequest){
        isSearchActive = true
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        client.fetchSearchMovies(with: request, page: currentPage) { result in
            switch result {
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onSearchFetchFailed(with: error.reason)
                }
                
            case .success(let response):
                DispatchQueue.main.async {
                    
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    
                    self.total = response.totalMovies
                    
                    self.movies.append(contentsOf: response.movies)
                    
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
    
    override func fetchMovies() {
        isSearchActive = false
        queri = ""
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        client.fetchMovies(with: request, page: currentPage) { result in
            switch result {
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onPopularFetchFailed(with: error.reason)
                }
                
            case .success(let response):
                DispatchQueue.main.async {
                    
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    
                    self.total = response.totalMovies
                    self.movies.append(contentsOf: response.movies)
                    
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
