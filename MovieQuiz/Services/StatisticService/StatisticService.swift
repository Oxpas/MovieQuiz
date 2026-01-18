//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 14.01.2026.
//

import Foundation



final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrectAnswers
        case bestGameTotalAnswers
        case date
        case totalAccuracy
        case totalQuestions
        case totalCorrectAnswers
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrectAnswers.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotalAnswers.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
        
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrectAnswers.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotalAnswers.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalCorrectAnswers: Int = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        let totalQuestionAsked: Int = storage.integer(forKey: Keys.totalQuestions.rawValue)
        
        guard totalQuestionAsked > 0 else { return 0 }
        
        return Double(totalCorrectAnswers) / Double(totalQuestionAsked) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        let questions = storage.integer(forKey: Keys.totalQuestions.rawValue)
        let answers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        
        storage.set(questions + amount, forKey: Keys.totalQuestions.rawValue)
        storage.set(answers + count, forKey: Keys.totalCorrectAnswers.rawValue)
        
        gamesCount += 1
        
        let newRecord = GameResult(correct: count, total: amount, date: Date())
        
        if newRecord.isBetterThanOld(result: bestGame) {
            bestGame = newRecord
        }
        
        
    }
    
}
