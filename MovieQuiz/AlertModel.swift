//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 09.06.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: (() -> Void)
}
