//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 18.01.2026.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService: StatisticServiceProtocol?
    private var alertPresenter: AlertPresenter?
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        statisticService = StatisticService()
        let factory = QuestionFactory(moviesLoader: MoviesLoader())
        factory.delegate = self
        questionFactory = factory
        alertPresenter = AlertPresenter()
    }
    
    func loadData() {
        Task { [weak self] in
            await self?.questionFactory?.loadData()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                 question: model.text,
                                 questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func recordAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
    }
    
    func resetCorrectAnswers() {
        correctAnswers = 0
    }
    
    func noButtonTapped() {
        didAnswer(isYes: false)
    }
    
    func yesButtonTapped() {
        didAnswer(isYes: true)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let givenAnswer = isYes
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        recordAnswer(isCorrect: isCorrect)
        viewController?.showLoadingIndicator()
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    func showNextQuestionOrResult() {
        
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            
            guard let statisticService else { return }
            guard let viewController else { return }
            
            let accuracyFormatted = String(format: "%.2f", statisticService.totalAccuracy)
            let bestGame = statisticService.bestGame
            let bestGameDateFormatted = bestGame.date.dateTimeString
            
            let text = "Ваш результат: \(correctAnswers)/10\n" +
            "Количество сыгранных квизов: \(statisticService.gamesCount)\n" +
            "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGameDateFormatted))\n" +
            "Средняя точность: \(accuracyFormatted)%"
            
            let alertModel = AlertModel(title: "Этот раунд окончен",
                                       message: text,
                                       buttonText: "Сыграть еще раз") { [weak self] in
                self?.restartGame()
            }
            
            alertPresenter?.showAlert(in: viewController, model: alertModel)
        } else {
            self.switchToNextQuestion()
            
            Task { [weak self] in
                do {
                    try await self?.questionFactory?.requestNextQuestion()
                } catch {
                    // Ошибка уже обработана через didFailToLoadData
                }
            }
        }
    }
    
    func restartGame() {
        self.resetQuestionIndex()
        self.resetCorrectAnswers()
        
        Task { [weak self] in
            do {
                try await self?.questionFactory?.requestNextQuestion()
            } catch {
                // Ошибка уже обработана через didFailToLoadData
            }
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        
        Task { [weak self] in
            do {
                try await self?.questionFactory?.requestNextQuestion()
            } catch {
                // Ошибка уже обработана через didFailToLoadData
            }
        }
    }
    
    func didFailToLoadData(with error: Error) {
        guard let viewController else { return }
        
        viewController.hideLoadingIndicator()
        let alert = AlertModel(title: "Ошибка", message: error.localizedDescription, buttonText: "Попробовать еще раз") { [weak self] in
            self?.restartGame()
        }
        alertPresenter?.showAlert(in: viewController, model: alert)
    }
    
    @MainActor
    func didReceiveNextQuestion(question: QuizQuestion?) {
        viewController?.hideSkeleton()
        
        guard let question else { return }
        
        currentQuestion = question
        guard let currentQuestion else { return }
        
        let viewModel = convert(model: currentQuestion)
        
        viewController?.hideLoadingIndicator()
        viewController?.show(quiz: viewModel)
    }
}
