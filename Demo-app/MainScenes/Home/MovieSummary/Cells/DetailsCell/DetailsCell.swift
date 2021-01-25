//
//  DetailsCell.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import UIKit

class DetailsCell: UITableViewCell {

    // MARK: - Identifier

    static let cellIdentifier = "DetailsCell"
    static let nibName = "DetailsCell"
    
    // MARK: - Views
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }

    // MARK: - Setup
    
    private func setupUI() {
        containerView.layer.cornerRadius = 12
        
        // Add shadow to container view
        containerView.layer.shadowColor = Colors.customGray.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 2
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setup(withMovie movie: Movie) {
        titleLabel.text = movie.originalTitle
        releaseDateLabel.text = movie.releaseDate?.toDateFormattedString()
        ratingLabel.text = "\(movie.voteAverage)"
        
        switch movie.ratingRate {
        case .bad:
            ratingLabel.textColor = Colors.customRed
        case .medium:
            ratingLabel.textColor = Colors.customYellow
        case .good:
            ratingLabel.textColor = Colors.customGreen
        }
    }

}
