//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 22.06.2025.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
      private let networkClient: NetworkRouting
      
      init(networkClient: NetworkRouting = NetworkClient()) {
          self.networkClient = networkClient
      }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        print("Загрузка данных из: \(mostPopularMoviesUrl)")
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                print("Получены данные: \(String(data: data.prefix(100), encoding: .utf8) ?? "Нечитаемые данные")")
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    print("Ошибка декодирования: \(error)")
                    handler(.failure(error))
                }
            case .failure(let error):
                print("Сетевая ошибка: \(error)")
                handler(.failure(error))
            }
        }
    }
}
