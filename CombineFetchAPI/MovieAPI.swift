//
//  MovieAPI.swift
//  CombineFetchAPI
//
//  Created by Alfian Losari on 22/09/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import Combine


//class MovieAPI {
//
//    static let shared = MovieAPI()
//
//    private init() {}
//    private static let endpoint = URL(string: "http://localhost:3030/movies")!
//    private static let jsonDecoder = JSONDecoder()
//    private static var subscriptions = Set<AnyCancellable>()
//
//    func fetchMovies() -> Future<[Movie], MyAPIError> {
//        return Future<[Movie], MyAPIError> { promise in
//            URLSession.shared
//                .dataTaskPublisher(for: MovieAPI.endpoint)
//                .tryMap { (data, response) -> MovieResponse in
//                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
//                        throw MyAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
//                    }
//                    return try MovieAPI.jsonDecoder.decode(MovieResponse.self, from: data)
//            }
//            .receive(on: RunLoop.main)
//            .sink(receiveCompletion: { (completion) in
//                if case let .failure(error) = completion {
//                    switch error {
//                    case let urlError as URLError:
//                        promise(.failure(.urlError(urlError)))
//                    case let decodingError as DecodingError:
//                        promise(.failure(.decodingError(decodingError)))
//                    case let apiError as MyAPIError:
//                        promise(.failure(apiError))
//                    default:
//                        promise(.failure(.genericError))
//                    }
//                }
//                }, receiveValue: { promise(.success($0.data)) })
//                .store(in: &MovieAPI.subscriptions)
//        }
//    }
//}
