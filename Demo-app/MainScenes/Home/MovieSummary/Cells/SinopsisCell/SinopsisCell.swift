//
//  SinopsisCell.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import UIKit

class SinopsisCell: UITableViewCell {

    // MARK: - Identifier

    static let cellIdentifier = "SinopsisCell"
    static let nibName = "SinopsisCell"
    
    // MARK: - Views
    
    @IBOutlet weak var contentLabel: UILabel!
    
   // MARK: - Setup
    
    func setup(withMovie movie: Movie) {
        contentLabel.text = movie.overview
    }

}
