//
//  PagedMovieResponse.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

struct PagedMovieResponse: Decodable {
    let movies: [Movie]
    let totalMovies: Int
    let page: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalMovies = "total_results"
        case page = "page"
        case totalPages = "total_pages"
    }
}
