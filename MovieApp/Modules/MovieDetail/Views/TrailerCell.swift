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
        webView.scrollView.isScrollEnabled = false
        webView.configuration.allowsInlineMediaPlayback = true
        webView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func configure(url: URL) {
          let embedURL = url.absoluteString
          
          let htmlString = """
          <!DOCTYPE html>
          <html>
          <head>
              <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
              <meta name="referrer" content="strict-origin-when-cross-origin">
              <style>
                  * { margin: 0; padding: 0; box-sizing: border-box; }
                  html, body { width: 100%; height: 100%; background-color: #000; overflow: hidden; }
                  iframe { width: 100%; height: 100%; border: 0; }
              </style>
          </head>
          <body>
              <iframe 
                  width="100%" 
                  height="100%" 
                  src="\(embedURL)?playsinline=1&enablejsapi=1&origin=https://www.themoviedb.org" 
                  title="YouTube video player" 
                  frameborder="0" 
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                  referrerpolicy="strict-origin-when-cross-origin" 
                  allowfullscreen>
              </iframe>
          </body>
          </html>
          """
          
          webView.loadHTMLString(htmlString, baseURL: URL(string: "https://www.themoviedb.org"))
      }
}
