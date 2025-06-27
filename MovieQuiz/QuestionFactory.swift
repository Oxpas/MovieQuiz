//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 06.06.2025.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    //    private let questions: [QuizQuestion] = [
    //        QuizQuestion(
    //            image: "The Godfather",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Dark Knight",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Kill Bill",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Avengers",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Deadpool",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "The Green Knight",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: true),
    //        QuizQuestion(
    //            image: "Old",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "The Ice Age Adventures of Buck Wild",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "Tesla",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false),
    //        QuizQuestion(
    //            image: "Vivarium",
    //            text: "Рейтинг этого фильма больше чем 6?",
    //            correctAnswer: false)
    //    ]
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self, let movie = self.movies.randomElement() else { return }
            
            // Асинхронная загрузка изображения
            URLSession.shared.dataTask(with: movie.image) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.delegate?.didFailToLoadData(with: error)
                    }
                    return
                }
                
                guard let data = data else { return }
                let rating = Float(movie.rating) ?? 0
                let question = QuizQuestion(
                    image: data,
                    text: "Рейтинг этого фильма больше, чем 7?",
                    correctAnswer: rating > 7
                )
                
                DispatchQueue.main.async {
                    self.delegate?.didRecieveNextQuestion(question: question)
                }
            }.resume()
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
