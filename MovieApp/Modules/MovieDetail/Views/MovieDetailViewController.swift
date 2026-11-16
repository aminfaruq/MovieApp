//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
    var presenter: MovieDetailPresenterProtocol?
    
    private enum Section: Int, CaseIterable {
        case detail = 0
        case trailer = 1
        case reviews = 2
    }
    
    private var movieDetail: MovieDetailModel?
    private var trailerURL: URL?
    private var reviews: [MovieReviewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.register(UINib(nibName: MovieDetailCell.identifier, bundle: nil), forCellReuseIdentifier: MovieDetailCell.identifier)
        tableView.register(UINib(nibName: ReviewCell.identifier, bundle: nil), forCellReuseIdentifier: ReviewCell.identifier)
        tableView.register(UINib(nibName: TrailerCell.identifier, bundle: nil), forCellReuseIdentifier: TrailerCell.identifier)
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc func handleRefresh() {
        presenter?.viewDidLoad()
    }
    
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0}
        
        switch sectionType {
               case .detail:
                   return movieDetail == nil ? 0 : 1
               case .trailer:
                   return trailerURL == nil ? 0 : 1
               case .reviews:
                   return reviews.count
               }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch sectionType {
            case .detail:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailCell.identifier, for: indexPath) as? MovieDetailCell,
                      let movieDetail = movieDetail else {
                    return UITableViewCell()
                }
                cell.configure(model: movieDetail)
                return cell
                
            case .trailer:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TrailerCell.identifier, for: indexPath) as? TrailerCell,
                      let trailerURL = trailerURL else {
                    return UITableViewCell()
                }
                cell.configure(url: trailerURL)
                return cell
                
            case .reviews:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
                    return UITableViewCell()
                }
                cell.configure(model: reviews[indexPath.row])
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = Section(rawValue: section) else { return nil }
        
        switch sectionType {
            case .detail:
                return nil
            case .trailer:
                return nil
            case .reviews:
                return reviews.isEmpty ? nil : "User Reviews"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    func display(isLoading: Bool) {
        if isLoading {
            if !refreshControl.isRefreshing {
                activityIndicatorView.startAnimating()
            }
        } else {
            activityIndicatorView.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    func display(movie: MovieDetailModel) {
        self.movieDetail = movie
        tableView.reloadSections(IndexSet(integer: Section.detail.rawValue), with: .none)
    }
    
    func display(trailerURL: URL?) {
        self.trailerURL = trailerURL
        tableView.reloadSections(IndexSet(integer: Section.trailer.rawValue), with: .none)
    }
    
    func display(reviews: [MovieReviewModel]) {
        self.reviews = reviews
        tableView.reloadSections(IndexSet(integer: Section.reviews.rawValue), with: .none)
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
    
    func display(showErrorMessage: String) {
        let alert = UIAlertController(title: "Error", message: showErrorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
