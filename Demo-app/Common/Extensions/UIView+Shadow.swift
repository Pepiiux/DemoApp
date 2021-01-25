//
//  UIView+Shadow.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import UIKit

extension UIView {

    func dropShadow(color: UIColor = UIColor(red: 49/255.0, green: 65/255.0, blue: 104/255.0, alpha: 1), opacity: Float = 0.18, offSet: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 8, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}
