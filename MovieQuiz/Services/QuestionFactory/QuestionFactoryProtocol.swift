//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 14.01.2026.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() async throws
    func loadData() async
}
