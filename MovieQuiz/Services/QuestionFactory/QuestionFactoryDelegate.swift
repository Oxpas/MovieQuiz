//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 14.01.2026.
//

import Foundation

@MainActor
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
