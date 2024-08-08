//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Richard Basdeo on 7/30/24.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check internet connection."
    case invalidResponse = "Invalid response from the server, please try again"
    case invalidData = "The data received from the server was invalid."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user."
}
