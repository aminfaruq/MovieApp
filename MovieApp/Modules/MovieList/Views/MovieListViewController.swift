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
    private var movies = [MovieModel]()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        presenter?.viewDidLoad()
    }
    
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellReuseIdentifier: MovieCell.identifier)
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        presenter?.didPullToRefresh()
    }

}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { return UITableViewCell() }
        cell.configure(result: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            presenter?.didLoadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter?.didSelectMovie(id: movies[indexPath.row].id)
    }
}

extension MovieListViewController: MovieListViewProtocol {
    
    func display(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    func display(movies: [MovieModel]) {
        self.movies = movies
        self.tableView.reloadData()
    }
    
    func display(showErrorMessage: String) {
        let alert = UIAlertController(title: "Alert", message: showErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("retry", comment: "Default action"), style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.viewDidLoad()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func display(isPaginationLoading: Bool) {
        if isPaginationLoading {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            tableView.tableFooterView = spinner
        } else {
            tableView.tableFooterView = nil
        }
    }
}
