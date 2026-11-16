//
//  MovieDetailCell.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit
import Kingfisher
import SnapKit

class MovieDetailCell: UITableViewCell {
    
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var taglineLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    static let identifier = "MovieDetailCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backdropImageView.kf.cancelDownloadTask()
        backdropImageView.image = nil
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
    }
    
    func configure(model: MovieDetailModel) {
        backdropImageView.kf.indicatorType = .activity
        backdropImageView.kf.setImage(with: model.backdropPath)
        titleLabel.text = model.title
        taglineLabel.text = model.tagline
        releaseDateLabel.text = model.releaseDate
        ratingLabel.text = model.voteAverage
        overviewLabel.text = model.overview
        
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        view.snp.makeConstraints { make in
            make.height.equalTo(25)
        }
        
        label.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(12)
            make.trailing.bottom.equalToSuperview().inset(12)
        }
        
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for genre in model.genres {
            let badgeView = makeGenreBadge(title: genre.name)
            stackView.addArrangedSubview(badgeView)
        }
    }
    
    private func makeGenreBadge(title: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray5
        container.layer.cornerRadius = 6
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        return container
    }
}
