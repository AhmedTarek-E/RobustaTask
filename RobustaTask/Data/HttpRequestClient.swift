//
//  HttpRequestClient.swift
//  RobustaTask
//
//  Created by Ahmed Tarek on 24/05/2022.
//

import Foundation

class HttpRequestClient {
    static let shared = HttpRequestClient()
    
    private init() {}
    
    func sendRequest(
        url: URL,
        completionHandler: @escaping (AppResult<Data>) -> ()
    ) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                completionHandler(.success(data: data))
            } else if let error = error {
                print("Error: \(error)")
                completionHandler(.failure(error: "Something went wrong"))
            } else {
                completionHandler(.failure(error: "Invalid Response"))
            }
        }
        
        task.resume()
    }
}
