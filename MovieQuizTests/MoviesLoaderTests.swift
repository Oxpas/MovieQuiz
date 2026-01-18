//
//  MoviesLoaderTests.swift
//  MovieQuizTests
//
//  Created by Николай Замараев on 17.01.2026.
//

import Foundation
import XCTest
@testable import MovieQuiz

struct StubNetworkClient: NetworkRouting {
    enum TestError: Error {
        case test
    }
    
    let emulateError: Bool
    
    func fetch(url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            if emulateError {
                continuation.resume(throwing: TestError.test)
            } else {
                continuation.resume(returning: expectedResponse)
            }
        }
    }
    
    private var expectedResponse: Data {
            """
            {
               "errorMessage" : "",
               "items" : [
                  {
                     "crew" : "Dan Trachtenberg (dir.), Amber Midthunder, Dakota Beavers",
                     "fullTitle" : "Prey (2022)",
                     "id" : "tt11866324",
                     "imDbRating" : "7.2",
                     "imDbRatingCount" : "93332",
                     "image" : "https://...",
                     "rank" : "1",
                     "rankUpDown" : "+23",
                     "title" : "Prey",
                     "year" : "2022"
                  }
               ]
            }
            """.data(using: .utf8)!
    }
}

class MoviesLoaderTests: XCTestCase {
    
    func testSuccessLoading() async throws {
        // GIVEN
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        // WHEN
        let movies = try await loader.loadMovies()
        // THEN
        XCTAssertEqual(movies.count, 1)
        XCTAssertFalse(movies.isEmpty, "Movies list should not be empty")
    }
    
    func testFailureLoading() async throws {
        // GIVEN
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        // WHEN THEN
        do {
            _ = try await loader.loadMovies()
            XCTFail("Expected error, but success received")
        } catch {
            XCTAssertTrue(error is StubNetworkClient.TestError)
        }
    }
}
