//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with movie: Movie?) {
        if let movie = movie {
            print(movie.poster_path)
            labelName.text = movie.title
            labelOverview.text = movie.overview
            labelDate.text = "\(movie.release_date)"
            posterImage.image = UIImage(url: URL(string: "http://image.tmdb.org/t/p/w92" + movie.poster_path!))
        } else {
            
        }
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

