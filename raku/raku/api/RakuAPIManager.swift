//
//  RakuAPIManager.swift
//  raku
//
//  Created by Anish Agrawal on 12/9/24.
//

import Foundation

// MARK: - RakuAPIManager
struct RakuAPIManager {
    static let shared = RakuAPIManager()
    private let baseURL = "https://api.anish.xyz/raku/v1/contributions/"
    
    private init() {}
    
    func fetchContributions(
        for username: String,
        startDate: Date? = nil,
        endDate: Date? = nil,
        completion: @escaping (Result<ContributionResponse, Error>) -> Void
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Build the URL with query parameters
        var urlComponents = URLComponents(string: baseURL + username)
        var queryItems: [URLQueryItem] = []
        
        if let startDate = startDate {
            queryItems.append(URLQueryItem(name: "start", value: dateFormatter.string(from: startDate)))
        }
        if let endDate = endDate {
            queryItems.append(URLQueryItem(name: "end", value: dateFormatter.string(from: endDate)))
        }
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let contributionResponse = try decoder.decode(ContributionResponse.self, from: data)
                completion(.success(contributionResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// MARK: - ContributionResponse
struct ContributionResponse: Decodable {
    let user: String
    let contributions: [Contribution]
}

// MARK: - Contribution
struct Contribution: Decodable {
    let date: Date
    let count: Int
}

// MARK: - NetworkError
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}
