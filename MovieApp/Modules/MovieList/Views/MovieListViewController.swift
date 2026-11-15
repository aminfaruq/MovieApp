//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: MovieListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func configure() {
        
    }

}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MovieListViewController: MovieListViewProtocol {
    func display(isLoading: Bool) {
        
    }
    
    func display(movies: [MovieModel]) {
        
    }
    
    func display(showErrorMessage: String) {
        
    }
    
    func display(isPaginationLoading: Bool) {
        
    }
}
