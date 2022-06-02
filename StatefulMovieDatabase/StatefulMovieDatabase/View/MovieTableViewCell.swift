//
//  MovieTableViewCell.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var image: UIImage? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    func setConfiguration(with movie: ResultsDictionary) {
        fetchImage(for: movie)
        var configuration = defaultContentConfiguration()
        configuration.text = movie.title
        configuration.secondaryText = movie.overview
        configuration.secondaryTextProperties.numberOfLines = 4
        configuration.imageProperties.maximumSize = CGSize(width: 50, height: 100)
        contentConfiguration = configuration
    }
    
    func fetchImage(for movie: ResultsDictionary) {
        guard let imageString = movie.posterPathString else {return}
        NetworkController.fetchPosterPath(for: imageString) { result in
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
            case.failure(let error):
                print("There has been an error", error.errorDescription!)
          }
        }
     }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        // Called when the image is set
        super.updateConfiguration(using: state)
        guard var configuration = contentConfiguration as? UIListContentConfiguration else { return }
        configuration.image = self.image
        contentConfiguration = configuration
    }
}

// MARK: - Functions

