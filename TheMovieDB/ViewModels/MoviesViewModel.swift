//
//  MovieViewModel.swift
//  TheMovieDB
//
//  Created by Pavle on 20.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

class MoviesViewModel {
    var movies: [Movie] = []
    var currentPage = 1
    var total = 0
    var isFetchInProgress = false
    
    let client = MovieClient()
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return movies.count
    }
    
    func movie(at index: Int) -> Movie {
        return movies[index]
    }
    
    func fetchMovies() {
        
    }
    
    func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
