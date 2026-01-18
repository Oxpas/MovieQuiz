//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 14.01.2026.
//

import Foundation

@MainActor
final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private let networkClient = NetworkClient()
    weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading = MoviesLoader()) {
        self.moviesLoader = moviesLoader
    }
    
//    private let questions: [QuizQuestion] = [
//        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
//        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
//    ]
    
    
    func requestNextQuestion() async throws {
        guard let movie = movies.randomElement() else {
            delegate?.didFailToLoadData(with: NSError(domain: "QuestionFactory", code: 1, userInfo: [NSLocalizedDescriptionKey: "Нет доступных фильмов"]))
            return
        }

        do {
            let imageData = try await networkClient.fetch(url: movie.imageURL)

            let rating = Float(movie.rating) ?? 0
            let question = QuizQuestion(
                image: imageData,
                text: "Рейтинг этого фильма больше чем 7?",
                correctAnswer: rating > 7
            )

            delegate?.didReceiveNextQuestion(question: question)
        } catch {
            delegate?.didFailToLoadData(with: error)
            throw error
        }
    }

    func loadData() async {
        do {
            movies = try await moviesLoader.loadMovies()
            delegate?.didLoadDataFromServer()
        } catch {
            delegate?.didFailToLoadData(with: error)
        }
    }
}
