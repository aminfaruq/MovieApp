//
//  ReviewCell.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var reviewLabel: UILabel!
    
    static let identifier = "ReviewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: MovieReviewModel) {
        usernameLabel.text = model.username
        ratingLabel.text = model.rating
        reviewLabel.text = model.content
    }
    
}
