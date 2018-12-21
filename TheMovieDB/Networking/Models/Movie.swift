//
//  Movie.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let title: String
    let release_date: String
    let poster_path: String?
    let overview: String

    let vote_count: Int
    let id: Int
    let video: Bool
    let vote_average: Float
    let popularity: Float
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let backdrop_path: String?
    let adult: Bool

    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case release_date = "release_date"
        case poster_path = "poster_path"
        case overview = "overview"

        case vote_count = "vote_count"
        case id = "id"
        case video = "video"
        case vote_average = "vote_average"
        case popularity = "popularity"
        case original_language = "original_language"
        case original_title = "original_title"
        case genre_ids = "genre_ids"
        case backdrop_path = "backdrop_path"
        case adult = "adult"
    }
    
    init(title: String, release_date: String, poster_path: String?, overview: String, vote_count: Int, id: Int, video: Bool, vote_average: Float, popularity: Float, original_language: String, original_title: String, genre_ids: [Int], backdrop_path: String?, adult: Bool) {
        
        self.title = title
        self.release_date = release_date
        self.poster_path = poster_path
        self.overview = overview

        self.vote_count = vote_count
        self.id = id
        self.video = video
        self.vote_average = vote_average
        self.popularity = popularity
        self.original_language = original_language
        self.original_title = original_title
        self.genre_ids = genre_ids
        self.backdrop_path = backdrop_path
        self.adult = adult
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let release_date = try container.decode(String.self, forKey: .release_date)
        let poster_path = try container.decode(String?.self, forKey: .poster_path)
        let overview = try container.decode(String.self, forKey: .overview)

        let vote_count = try container.decode(Int.self, forKey: .vote_count)
        let id = try container.decode(Int.self, forKey: .id)
        let video = try container.decode(Bool.self, forKey: .video)
        let vote_average = try container.decode(Float.self, forKey: .vote_average)
        let popularity = try container.decode(Float.self, forKey: .popularity)
        let original_language = try container.decode(String.self, forKey: .original_language)
        let original_title = try container.decode(String.self, forKey: .original_title)
        let genre_ids = try container.decode([Int].self, forKey: .genre_ids)
        let backdrop_path = try container.decode(String?.self, forKey: .backdrop_path)
        let adult = try container.decode(Bool.self, forKey: .adult)
        
        self.init(title: title, release_date: release_date, poster_path: poster_path, overview: overview, vote_count: vote_count, id: id, video: video, vote_average: vote_average, popularity: popularity, original_language: original_language, original_title: original_title, genre_ids: genre_ids, backdrop_path: backdrop_path, adult: adult)
        
    }
}
