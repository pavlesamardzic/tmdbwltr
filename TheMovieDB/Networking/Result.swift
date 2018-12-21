//
//  Result.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
