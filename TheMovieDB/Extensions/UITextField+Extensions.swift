//
//  UITextField+Extensions.swift
//  TheMovieDB
//
//  Created by Pavle on 18.12.18..
//  Copyright © 2018. Pavle. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setBottomBorder() {
        borderStyle = .none
        layer.backgroundColor = UIColor.white.cgColor
        
        layer.masksToBounds = false
        
        layer.shadowColor = ColorPalette.RWGreen.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }
}
