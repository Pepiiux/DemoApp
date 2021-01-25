//
//  UIImageView+Loading.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import UIKit
import Kingfisher

enum ImageSize: String {
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
    case original = "original"
}
enum ImageType {
    case poster
    case avatar
}

extension UIImageView {

    func setImage(withEndpoint endpoint: String?, imageType: ImageType, placeholder: UIImage? = nil, size: ImageSize = .original) {
        guard let endpoint = endpoint else {
            self.image = placeholder
            return
        }
        
        let stringURL: String
        
        switch imageType {
        case .poster:
            stringURL = "\(ConfigurationManager.sharedInstance.imageBaseURL)\(size.rawValue)\(endpoint)"
        case .avatar:
            if endpoint.contains("https") {
                stringURL = endpoint
            } else {
                stringURL = "\(ConfigurationManager.sharedInstance.imageBaseURL)\(size.rawValue)\(endpoint)"
            }
        }

        let url = URL(string: stringURL)
        self.kf.setImage(with: url, placeholder: placeholder)
    }
    
}
