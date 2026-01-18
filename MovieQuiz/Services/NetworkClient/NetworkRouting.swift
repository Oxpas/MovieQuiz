//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 17.01.2026.
//

import Foundation
protocol NetworkRouting {
    func fetch(url: URL) async throws -> Data
}
