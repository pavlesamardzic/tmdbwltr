//
//  SearchMovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Pavle on 19.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import UIKit

class SearchMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterViewInSearch: UIImageView!
    @IBOutlet weak var labelNameInSearch: UILabel!
    @IBOutlet weak var labelOverviewInSearch: UILabel!
    @IBOutlet weak var labelDateInSearch: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func onClickButtonSearch(_ sender: Any) {
        configure(with: .none)
    }
    
    func configure(with title: String?) {
        if let title = title {
            labelNameInSearch.text = title
            
        } else {
            
        }
    }
}
