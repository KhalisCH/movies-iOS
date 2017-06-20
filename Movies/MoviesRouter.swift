//
//  MoviesRouter.swift
//  Movies
//
//  Created by Khalis on 20/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

//
//  MovieDatabaseRouter
//  Movies
//
//  Created by Khalis on 19/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import Foundation
import Alamofire

public enum MoviesRouter: URLRequestConvertible {
    /*** Base URL and API key ***/
    static let baseURLPath = "https://movies-backend.herokuapp.com"
    
    /*** Movie ***/
    case connection(username: String, password: String)                    //Connection of a user
    case inscription(email: String, username: String, password: String) //Inscription of a user
    case addFavorite(userID: Int, videoID: Int, type: String)           //Add a favorite
    case deleteFavorite(userID: Int, videoID: Int, type: String)        //Delete a favorite
    case getFavorite(userID: Int)                                       //Get the favorite of a user

    
    
    /*** HTTP METHOD ***/
    var method: HTTPMethod {
        switch self {
        case .getFavorite:
            return .get
        case .connection, .inscription, .addFavorite:
            return .post
        case .deleteFavorite:
            return .delete
        }
    }
    
    /*** URL for the request ***/
    var path: String {
        switch self {
        case .connection:
            return "/api/user/connect"
        case .inscription:
            return "/api/user/subscribe"
        case .addFavorite, .deleteFavorite:
            return "/api/favorite"
        case .getFavorite(let userID):
            return "/api/favorite/" + String(userID)
        }
    }
    
    /*** Query parameters ***/
    public func asURLRequest() throws -> URLRequest {
        let parameters: Parameters = {
            switch self {
            case .connection(let username, let password):
                return ["username": username, "password": password]
            case .inscription(let email, let username, let password):
                return ["email": email, "username": username, "password": password]
            case .addFavorite(let userId, let videoID, let type), .deleteFavorite(let userId, let videoID, let type):
                return ["userId": userId, "videoID": videoID, "videoType": type]
            default:
                return [:]
            }
        }()
        
        let url = try MoviesRouter.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try JSONEncoding.default.encode(request, with: parameters)
    }
}
