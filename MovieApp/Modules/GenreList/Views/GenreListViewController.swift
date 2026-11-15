//
//  GenreListViewController.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import UIKit

class GenreListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    public var presenter: GenreListPresenterProtocol?
    
    private let refreshControl = UIRefreshControl()
    private var genres = [GenreModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        presenter?.viewDidLoad()
    }
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: GenreCell.identifier, bundle: nil), forCellReuseIdentifier: GenreCell.identifier)
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc func didPullToRefresh() {
        presenter?.viewDidLoad()
    }
}

extension GenreListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else { return UITableViewCell() }
        cell.configure(result: genres[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presenter?.didSelectGenre(genre: genres[indexPath.row])
    }
}

extension GenreListViewController: GenreListViewProtocol {
    func display(isLoading: Bool) {
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    func display(genres: [GenreModel]) {
        self.genres = genres
        self.tableView.reloadData()
    }
    
    func display(showErrorMessage: String) {
        let alert = UIAlertController(title: "Alert", message: showErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.viewDidLoad()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
