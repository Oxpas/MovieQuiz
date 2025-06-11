//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 09.06.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
