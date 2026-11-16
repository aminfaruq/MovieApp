//
//  MovieCell.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    
    static let identifier = "MovieCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.layer.cornerRadius = 8
        posterImageView.image = nil
    }
    
    func configure(result: MovieModel) {
        titleLabel.text = result.title
        releaseDateLabel.text = result.releaseDate
        ratingLabel.text = result.voteAverage
        overviewLabel.text = result.overview
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: result.posterPath)
    }
}
