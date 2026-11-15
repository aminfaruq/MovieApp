//
//  GenreCell.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import UIKit

class GenreCell: UITableViewCell {
    
    static let identifier = "GenreCell"

    @IBOutlet private weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(result: GenreModel) {
        genreLabel.text = result.name
    }
    
}
