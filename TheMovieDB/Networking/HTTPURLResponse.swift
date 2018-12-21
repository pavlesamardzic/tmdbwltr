//
//  HTTPURLResponse.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
