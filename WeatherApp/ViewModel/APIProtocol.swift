//
//  APIProtocol.swift
//  WeatherApp
//
//  Created by Stanislav Shelipov on 11.12.2022.
//

import Foundation
import Combine

protocol APIProtocol: Error {
    func fetch(url: String) -> AnyPublisher<URL, Error>
    func fetchData(_ url: URL) -> AnyPublisher<Data, Error>
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error>
    func load<T: Decodable>(url: String) -> AnyPublisher<T, Error>
}

