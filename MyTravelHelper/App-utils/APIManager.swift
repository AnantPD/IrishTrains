//
//  Extensions.swift
//  MyTravelHelper
//
//  Created by Prashant Paymal on 9/12/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import Foundation
import XMLParsing

enum APIError: Error {
    case serverError
    case parsingError
}

struct APIManager {
    
    static func get<T: Codable>(generalType: T.Type, url: URL, completion: @escaping (Result<T, Error>) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            DispatchQueue.main.async {
                guard error == nil
                else {
                    completion(.failure(error!))
                    return
                }

                do {
                    guard let data = data
                    else {
                        completion(.failure(APIError.serverError))
                        return
                    }
                    
                    let object = try XMLDecoder().decode(T.self, from: data)
                    completion(Result.success(object))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
    
}
