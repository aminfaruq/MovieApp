//
//  ReviewCell.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
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
