//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Николай Замараев on 15.01.2026.
//

import Foundation
import Alamofire

struct NetworkClient: NetworkRouting {
    
    private enum NetworkError: Error {
        case invalidResponse
        case badData
        case alamofireError
    }
    
    func fetch(url: URL) async throws -> Data {
        let request = AF.request(url)
        
        let response = await request.serializingData().response
        
        if let error = response.error {
            throw NetworkError.alamofireError
        }
        
        if let statusCode = response.response?.statusCode,
           !(200..<300).contains(statusCode) {
            throw NetworkError.invalidResponse
        }
        
        guard let data = response.data else {
            throw NetworkError.badData
        }
        
        return data
    }
}
