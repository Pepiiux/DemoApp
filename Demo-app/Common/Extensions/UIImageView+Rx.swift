//
//  UIImageView+Rx.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIImageView {
    
    var setMoviePosterImage: Binder<String?> {
        return Binder<String?>(self.base) { imageView, endpoint in
            imageView.setImage(withEndpoint: endpoint, imageType: .poster)
        }
    }
    
}
