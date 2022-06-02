//
//  MovieListTableViewController.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import UIKit

class MovieListTableViewController: UITableViewController {
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    var movieList: [ResultsDictionary] = []
    var posterPath: ResultsDictionary?
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movieList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        let movie = movieList[indexPath.row]
        cell.setConfiguration(with: movie)
        
        return cell
    }
    
}// end of class 

extension MovieListTableViewController: UISearchBarDelegate {

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text else {
            print("No text entered.")
            return
        }

        
        NetworkController.fetchMovieDictionary(with: searchTerm ) { result in
            switch result {
            case.success(let movie):
                DispatchQueue.main.async {
                    self.movieList = movie.results
                    self.tableView.reloadData()
                    self.searchBar.resignFirstResponder()
                }
            case.failure(let error):
                print("There has been an error!", error.errorDescription!)
                
        }
    }
        
//        NetworkController.fetchPosterPath(for: <#T##String#>, completion: <#T##(Result<UIImage, ResultError>) -> Void#>)
}
    
    
}
    

