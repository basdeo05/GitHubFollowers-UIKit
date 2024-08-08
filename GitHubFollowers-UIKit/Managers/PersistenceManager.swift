//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 8/7/24.
//

import Foundation

enum PersistenceActionType {
    case add
    case remove
}

enum PersistenceManager{
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completionHandler: @escaping (GFError?) -> Void){
        
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                
                var retrievedFavorties = favorites
                
                switch actionType {
                case .add:
                    
                    guard !retrievedFavorties.contains(favorite) else {
                        completionHandler(.alreadyInFavorites)
                        return
                    }
                    
                    retrievedFavorties.append(favorite)
                case .remove:
                    retrievedFavorties.removeAll(where: {$0.login == favorite.login})
                }
                
                completionHandler(save(favorites: retrievedFavorties))
                
            case .failure(let error):
                completionHandler (error)
            }
        }
    }
    
    static func retrieveFavorites (completionHandler: @escaping (Result<[Follower], GFError>) -> Void){
    
        guard let favortiesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completionHandler(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favortiesData)
            completionHandler(.success(favorites))
        }
        catch {
            completionHandler(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GFError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        }
        catch {
            return .unableToFavorite
        }
    }
}
