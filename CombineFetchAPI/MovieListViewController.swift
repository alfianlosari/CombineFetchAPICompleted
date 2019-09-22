//
//  MovieListViewController.swift
//  CombineFetchAPI
//
//  Created by Alfian Losari on 22/09/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import UIKit
import Combine

fileprivate enum Section {
    case main
}

class MovieListViewController: UITableViewController {

    fileprivate var diffableDataSource: UITableViewDiffableDataSource<Section, Movie>!
    private var subscriptions = Set<AnyCancellable>()
    var movieAPI = MovieStore.shared
    lazy var activityIndicator: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        $0.center = self.view.center
        self.view.addSubview($0)
        return $0
    }(UIActivityIndicatorView(style: .large))
    var isFetchingData = CurrentValueSubject<Bool, Never>(false)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Combine X API Fetch"
        setupTableView()
        bindActivityIndicator()
        fetchMovies()
    }

    func bindActivityIndicator() {
        isFetchingData
            .assign(to: \UIActivityIndicatorView.combine_isAnimating, on: self.activityIndicator)
            .store(in: &subscriptions)
    }
    
    func fetchMovies() {
        isFetchingData.value = true
        self.movieAPI.fetchMovies(from: .nowPlaying)
            .sink(receiveCompletion: {[unowned self] (completion) in
                if case let .failure(error) = completion {
                    self.handleError(apiError: error)
                }
                self.isFetchingData.value = false
            }, receiveValue: { [unowned self] in self.generateSnapshot(with: $0)
            })
            .store(in: &self.subscriptions)
    }
    
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        diffableDataSource = UITableViewDiffableDataSource<Section, Movie>(tableView: tableView) { (tableView, indexPath, movie) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = movie.title
            return cell
        }
    }
    
    
    private func generateSnapshot(with movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func handleError(apiError: MovieStoreAPIError) {
        let alertController = UIAlertController(title: "Error", message: apiError.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true)
    }
}


fileprivate extension UIActivityIndicatorView {
    
    var combine_isAnimating: Bool  {
        set {
            if (newValue) {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
        
        get {
            return isAnimating
        }
        
    }
    
    
    
}
