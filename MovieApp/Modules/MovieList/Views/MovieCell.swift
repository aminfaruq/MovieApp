//
//  MovieCell.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.kf.cancelDownloadTask()
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
