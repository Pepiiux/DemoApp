//
//  ReviewCell.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import UIKit

class ReviewCell: UITableViewCell {

    // MARK: - Identifier

    static let cellIdentifier = "ReviewCell"
    static let nibName = "ReviewCell"
    
    // MARK: - Views
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Setup
    
    func setupUI() {
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = Colors.customGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
    }
    
    func setup(withReview review: Review) {
        usernameLabel.text = review.details?.username
        ratingLabel.text = "\(review.details?.rating ?? 0)"
        reviewLabel.text = review.content?.htmlToString
        
        switch review.details?.ratingRate {
        case .bad, .none:
            ratingLabel.textColor = Colors.customRed
        case .medium:
            ratingLabel.textColor = Colors.customYellow
        case .good:
            ratingLabel.textColor = Colors.customGreen
        }
        
        if let imagePath = review.details?.avatarPath {
            profileImage.setImage(withEndpoint: imagePath, imageType: .poster)
        }
    }

}
