//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 14.01.2026.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThanOld(result: GameResult) -> Bool {
        correct > result.correct
    }
}
