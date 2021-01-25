//
//  movieCell.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import UIKit
import UICollectionViewParallaxCell

class movieCell: UICollectionViewParallaxCell {
    
    // MARK: - Identifiers

    static let cellIdentifier = "movieCell"
    static let nibName = "movieCell"

    // MARK: - Outlets
    
    @IBOutlet weak var movieImage: UIImageView!
    
    // MARK: - Setup
    
    func setup(movie: Movie) {
        movieImage.setImage(withEndpoint: movie.posterPath, imageType: .poster, size: .w185)
        movieImage.contentMode = .scaleAspectFill
        setupbackgroundParallax(imageView: movieImage, cornerRadius: 0, paddingOffset: paddingOffset, topConstraint: 0, bottomConstraint: 0, leadingConstraint: 0, trailingConstraint: 0)
    }

}
