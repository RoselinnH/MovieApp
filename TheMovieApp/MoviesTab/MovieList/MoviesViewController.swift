//
//  MoviesViewController.swift
//  TheMovieApp
//
//  Created by Rose H on 2019-08-09.
//  Copyright © 2019 Rose H. All rights reserved.
//

import Foundation
import UIKit

class StateController {
    
    var movieList = MovieList()
    var searchMovies: [Movie]?
    var movies: [Movie]?
    var favouriteMovies: [Movie] = []
}

class MoviesViewController: UIViewController {
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var movieList = MovieList()
    var searchMovieList = MovieList()
    var stateController = StateController()
    var favouritesOnly = false
    var movies: [Movie]?
    var searchMovies: [Movie]?
    private(set) var list = [Movie]()
    private(set) var searchList = [Movie]()
    private var moviesPage = 1
    private var searchPage = 1
    private var isSearching = false
    private var searchQuery: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setMovies()
        self.table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationController()
        let customCell = UINib(nibName: "MovieCustomCell", bundle: nil)
        self.table.register(customCell, forCellReuseIdentifier: "MovieCustomCell")
        self.table.dataSource = self
        self.table.delegate = self
        self.searchBar.delegate = self
        self.fetchAndRenderMovieList()

    }
    
    func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.2353, blue: 0.4878, alpha: 1.0)
        if self.favouritesOnly{
            self.navigationItem.title = "Favourites"
        } else {
            self.navigationItem.title = "Movies"
        }
    }
    
    func setMovies(){
        if self.favouritesOnly{
            self.movies = stateController.favouriteMovies
        } else {
            if self.isSearching {
                self.searchMovies = stateController.searchMovies
            } else {
                self.movies = stateController.movies
            }
        }
    }
    
    func fetchAndRenderMovieList() {
        self.isSearching = false
        self.movieList.setList(pageNumber: self.moviesPage, query: nil, isTyping: false) { [weak self] in
            guard let listOfMovies = self?.movieList.list else {return}
            self?.stateController.movies = listOfMovies
            self?.setMovies()
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
            self?.moviesPage += 1
        }
    }
    
    func fetchAndRenderSearchMovieList(isTyping: Bool) {
        if isTyping {
            self.searchPage = 1
        } else {
            self.searchPage += 1
        }
        self.searchMovieList.setList(pageNumber: self.searchPage, query: self.searchQuery, isTyping: isTyping) { [weak self] in
            DispatchQueue.main.async {
                guard let listOfSearchMovies = self?.searchMovieList.list else {return}
                self?.stateController.searchMovies = listOfSearchMovies
                self?.setMovies()
                self?.table.reloadData()
            }
        }
    }
}

extension MoviesViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MoviesDetailViewController", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? MoviesDetailViewController else {return}
        if self.isSearching {
            guard let searchMovies = self.searchMovies else {return}
            viewController.setIBOutlests(movie: searchMovies[indexPath.row])
        } else {
            guard let movies = self.movies else {return}
            viewController.setIBOutlests(movie: movies[indexPath.row])
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let askAction = UIContextualAction(style: .normal, title: nil) { action, view, complete in
            
            if self.isSearching {
                guard let favorite = self.stateController.searchMovies?[indexPath.row] else { return }
                self.stateController.favouriteMovies.append(favorite)
            }
            else if self.favouritesOnly {
                self.stateController.favouriteMovies.remove(at: indexPath.row)
                self.setMovies()
                self.table.deleteRows(at: [indexPath], with: .left)
            } else {
                guard let favorite = self.stateController.movies?[indexPath.row] else { return }
                if self.stateController.favouriteMovies.firstIndex(where: { $0.title == favorite.title }) == nil  {
                    self.stateController.favouriteMovies.append(favorite)
                }
            }
            complete(true)
        }
        
        if favouritesOnly {
            askAction.image = UIImage(named: "Remove")
            askAction.backgroundColor = UIColor(red: 0.8275, green: 0.149, blue: 0, alpha: 1.0)
        } else {
            askAction.image = UIImage(named: "FavouriteStar")
            askAction.backgroundColor = UIColor(red: 0.9569, green: 0.7176, blue: 0.1608, alpha: 1.0) 
        }
        return UISwipeActionsConfiguration(actions: [askAction])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if (distanceFromBottom * 0.65) < height {
            if self.isSearching {
                self.fetchAndRenderSearchMovieList(isTyping: false)
            } else {
                self.fetchAndRenderMovieList()
            }
        }
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.isSearching = false
            self.searchPage = 1
            self.moviesPage =  1
            return self.fetchAndRenderMovieList()
        }
        self.isSearching = true
        self.searchQuery = "&query=" + searchText + "&page="
        self.fetchAndRenderSearchMovieList(isTyping: true)
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching ? self.searchMovies?.count ?? 0 : self.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "MovieCustomCell", for: indexPath) as! MovieCustomCell
        if self.isSearching {
            guard let searchMovies = self.searchMovies else { return cell }
            cell.setUp(with: searchMovies[indexPath.row])
        } else {
            guard let movies = self.movies else { return cell }
            cell.setUp(with: movies[indexPath.row])
        }
        return cell
    }
}
