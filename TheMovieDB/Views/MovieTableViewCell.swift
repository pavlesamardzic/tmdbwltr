//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import UIKit
let imageCache = NSCache<NSString, AnyObject>()

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
            labelName.text = movie.title
            labelOverview.text = movie.overview
            labelDate.text = "\(movie.release_date)"
            if (movie.poster_path == nil) {
                posterImage.image = UIImage.self()
            } else {
                
                UIImageView().loadImageUsingCache(urlString: "http://image.tmdb.org/t/p/w92" + movie.poster_path!, posterImage: posterImage)
            }
        } else {
        }
    }
}

extension UIImageView {
    func loadImageUsingCache(urlString: String, posterImage: UIImageView) {
        let url = URL(string: urlString)
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            posterImage.image = self.image
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    posterImage.image = self.image
                }
            }
            
        }).resume()
    }
}
