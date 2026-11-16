//
//  TrailerCell.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit
import WebKit

class TrailerCell: UITableViewCell {
    @IBOutlet private weak var webView: WKWebView!
    
    static let identifier = "TrailerCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(url: URL) {
        webView.load(URLRequest(url: url))
    }
}
