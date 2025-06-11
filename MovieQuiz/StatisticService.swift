import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case correctAnswers = "correctAnswers"
        case totalQuestions = "totalQuestions"
        case bestGameDate = "bestGameDate"
        case bestGameCorrect = "bestGameCorrect"
        case bestGameTotal = "bestGameTotal"
        case gamesCount = "gamesCount"
    }
    
    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalCorrect = storage.integer(forKey: Keys.correctAnswers.rawValue) // Общее количество правильных ответов за игру
        let totalGames = storage.integer(forKey: Keys.gamesCount.rawValue) // Общее количество игр
        
        let result = Double(totalCorrect) / (10 * Double(totalGames)) * 100
        return result
    }
    
    func store(correct count: Int, total amount: Int) {
        
        let currentCorrect = storage.integer(forKey: Keys.correctAnswers.rawValue)
        let currentTotal = storage.integer(forKey: Keys.totalQuestions.rawValue)
        storage.set(currentCorrect + count, forKey: Keys.correctAnswers.rawValue)
        storage.set(currentTotal + amount, forKey: Keys.totalQuestions.rawValue)
        
        
        gamesCount += 1
        
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
    }
}
