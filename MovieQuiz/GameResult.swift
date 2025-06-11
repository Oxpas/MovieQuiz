//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 10.06.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
    
    var dateTimeString: String {
        date.dateTimeString
    }
    
}
