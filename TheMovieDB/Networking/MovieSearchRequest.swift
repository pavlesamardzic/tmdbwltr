//
//  MovieSearchRequest.swift
//  TheMovieDB
//
//  Created by Pavle on 20.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

struct MovieSearchRequest {
    var path: String {
        return "search/movie"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension MovieSearchRequest {
    static func from(query: String) -> MovieSearchRequest {
         let parameters = ["query": "\(query)"]
        return MovieSearchRequest(parameters: parameters)
    }
}
