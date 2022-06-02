//
//  NetworkController.swift
//  StatefulMovieDatabase
//
//  Created by Karl Pfister on 2/9/22.
//

import Foundation
import UIKit.UIImage

class NetworkController {
    static  let baseURL = URL(string: "https://api.themoviedb.org/3/search/movie")
    
    static func fetchMovieDictionary(with searchTerm: String, completion: @escaping (Result<MovieDictionary, ResultError>) -> Void ) {
        
        guard let baseURL = baseURL else {return}
        completion(.failure(.invalidURL(baseURL)))
        
        
         var urlComponents = URLComponents.init(url: baseURL, resolvingAgainstBaseURL: true)
        
        let apiKeyQuery = URLQueryItem(name: "api_key", value: "73946a66bdb733e0a5e80ecd8c0bb1c0")
        
        let searchQuery = URLQueryItem(name: "query", value: searchTerm)
        urlComponents?.queryItems = [apiKeyQuery,searchQuery]
        
        guard let finalURL = urlComponents?.url else {return}
        print(finalURL)
        completion(.failure(.invalidURL(finalURL)))
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                print("Encountered Error with \(finalURL)", error.localizedDescription)
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let movieDictionary = try JSONDecoder().decode(MovieDictionary.self, from: data)
                completion(.success(movieDictionary))
            }catch {
                completion(.failure(.unableToDecode))
                
            }
        }.resume()
    }
    static func fetchPosterPath(for posterPath: String, completion: @escaping (Result<UIImage, ResultError>)-> Void) {
        
        guard let baseImageURL = URL(string: "https://image.tmdb.org/t/p/w500") else {return}
        let finalURL = baseImageURL.appendingPathComponent(posterPath)
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("There has been an error", error.localizedDescription)
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                return
            }
            guard let posterImage = UIImage(data: data) else {
                completion(.failure(.unableToDecode))
                return
            }
            completion(.success(posterImage))
        }.resume()
    }
}// end of class

