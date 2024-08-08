//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/30/24.
//

import UIKit

class NetworkManager{
    
    static let shared = NetworkManager()
    private let baseUrl = "https://api.github.com/users/"
    
    //cache to hold user images, to prevent calling network call multiple times
    let cache = NSCache<NSString, UIImage>()
    
    private init () {
        
    }
    
    func getUserInfo (username: String, completionHandler: @escaping (Result<User, GFError>) -> Void){
        
        
        let endpoint = baseUrl + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                //This converts snake case to camel case without having to use CodingKeys
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let userInfo = try decoder.decode(User.self, from: data)
                completionHandler(.success(userInfo))
                return
            }
            catch {
                completionHandler(.failure(.invalidData))
                return
            }
        }
        task.resume()
    }
    
    
    
    
    
  
    func getFollowers (username: String, page: Int, completionHandler: @escaping (Result<[Follower], GFError>) -> Void){
        
        
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                //This converts snake case to camel case without having to use CodingKeys
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completionHandler(.success(followers))
                return
            }
            catch {
                completionHandler(.failure(.invalidData))
                return
            }
        }
        task.resume()  
    }
    
    
//    func getFollowers (username: String, page: Int, completionHandler: @escaping ([Follower]?, ErrorMessage?) -> Void){
//        
//        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
//        
//        guard let url = URL(string: endpoint) else {
//            completionHandler(nil, .invalidUsername)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            
//            if let _ = error {
//                completionHandler(nil, .unableToComplete)
//                return
//            }
//            
//            
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completionHandler(nil, .invalidResponse)
//                return
//            }
//            
//            guard let data = data else {
//                completionHandler(nil, .invalidData)
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                //This converts snake case to camel case without having to use CodingKeys
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let followers = try decoder.decode([Follower].self, from: data)
//                completionHandler(followers, nil)
//                return
//            }
//            catch {
//                completionHandler(nil, .invalidData)
//                return
//            }
//        }
//        task.resume()
//    }
}
