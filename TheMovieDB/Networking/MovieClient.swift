//
//  MovieClient.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

final class MovieClient {
    
    private lazy var baseURL: URL = {
        return URL(string: "http://api.themoviedb.org/3/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchMovies(with request: MovieRequest, page: Int,
                         completion: @escaping (Result<PagedMovieResponse, DataResponseError>) -> Void) {
        // 1
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        // 2
        let parameter = ["api_key" : "72f55c16869bd538f34e82cd2a794a44", "page": "\(page)"]
        // 3
        let encodedURLRequest = urlRequest.encode(with: parameter)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            // 4
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(DataResponseError.network))
                    return
            }
            
            // 5
            guard let decodedResponse = try? JSONDecoder().decode(PagedMovieResponse.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            // 6
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func fetchSearchMovies(with request: MovieSearchRequest, page: Int,
                     completion: @escaping (Result<PagedMovieResponse, DataResponseError>) -> Void) {
        // 1
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        // 2
        let parameter = ["api_key" : "72f55c16869bd538f34e82cd2a794a44", "page": "\(page)"].merging(request.parameters, uniquingKeysWith: +)
        // 3
        let encodedURLRequest = urlRequest.encode(with: parameter)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            // 4
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(DataResponseError.network))
                    return
            }
            
            // 5
            guard let decodedResponse = try? JSONDecoder().decode(PagedMovieResponse.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            // 6
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
}
