//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 15.01.2026.
//

import Foundation

protocol MoviesLoading {
    func loadMovies() async throws -> [MostPopularMovie]
}

struct MoviesLoader: MoviesLoading {
    //MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient:NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    //MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    //MARK: - Movies data loader
    func loadMovies() async throws -> [MostPopularMovie] {
        let data = try await networkClient.fetch(url: mostPopularMoviesUrl)
        let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
        
        return movies.items
    }
}
