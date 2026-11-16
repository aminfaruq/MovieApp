//
//  MovieDetailCell.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit
import Kingfisher

class MovieDetailCell: UITableViewCell {
    
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var taglineLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backdropImageView.kf.cancelDownloadTask()
        backdropImageView.image = nil
    }
    
    func configure(model: MovieDetailModel) {
        backdropImageView.kf.indicatorType = .activity
        backdropImageView.kf.setImage(with: model.backdropPath)
        titleLabel.text = model.title
        taglineLabel.text = model.tagline
        releaseDateLabel.text = model.releaseDate
        ratingLabel.text = model.voteAverage
        overviewLabel.text = model.overview
    }
    
}
