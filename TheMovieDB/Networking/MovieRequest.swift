//
//  MovieRequest.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

struct MovieRequest {
    var path: String {
        return "movie/popular"
    }
}

extension MovieRequest {
    static func from() -> MovieRequest {
        return MovieRequest()
    }
}
