//
//  MovieDatabaseRouter
//  Movies
//
//  Created by Khalis on 19/06/2017.
//  Copyright © 2017 Khalis. All rights reserved.
//

import Foundation
import Alamofire

public enum MovieDatabaseRouter: URLRequestConvertible {
    /*** Base URL and API key ***/
    static let baseURLPath = "https://api.themoviedb.org"
    static let authenticationToken = "332db8037d480cad9ce169f33c51f34a"
    
    /*** Movie ***/
    case popularMovie(language: String, page: Int)                  //Get the popular movie
    case upcomingMovie(language: String, page: Int, region: String) //Get the upcoming movie
    case topRatedMovie(language: String, page: Int)                 //Get the top rated movie
    case nowPlayingMovie(language: String, page: Int)               //Get the movie playing now
    case movieListGenre(language: String)                           //Get the list of genre for movies
    case movieDetails(id: Int, language: String)                    //Get the details of a specific movie
    case movieFilterByGenre(id: Int, language: String, page: Int)   //Get all the movies for a specific genre
    
    /*** TV Show ***/
    case popularTvShow(language: String, page: Int)                 //Get the popular TV show
    case nowPlayingTvShow(language: String, page: Int)              //Get the TV Show playing now
    case topRatedTvShow(language: String, page: Int)                //Get the top rated TV show
    case tvShowListGenre(language: String)                          //Get the list of genre for TV shows
    case tvShowDetails(id: Int, language: String)                   //Get the details of a specific TV show
    case tvShowFilterByGenre(id: Int, language: String, page: Int)  //Get all the TV shows for a specific genre
    
    /*** Communs ***/
    case poster(path: String)                                       //Get the poster of a movie
    
    
    /*** HTTP METHOD ***/
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    /*** URL for the request ***/
    var path: String {
        switch self {
        case .popularMovie:
            return "/3/movie/popular"
        case .upcomingMovie:
            return "/3/movie/upcoming"
        case .topRatedMovie:
            return "/3/movie/top_rated"
        case .nowPlayingMovie:
            return "/3/movie/now_playing"
        case .movieListGenre:
            return "/3/genre/movie/list"
        case .movieDetails:
            return "/3/movie"
        case .movieFilterByGenre:
            return "/3/genre"
        case .popularTvShow:
            return "/3/tv/popular"
        case .nowPlayingTvShow:
            return "/3/tv/on_the_air"
        case .topRatedTvShow:
            return "/3/tv/top_rated"
        case .tvShowListGenre:
            return "/3/genre/tv/list"
        case .tvShowDetails:
            return "/3/tv"
        case .tvShowFilterByGenre:
            return "/3/discover/tv"
        case .poster:
            return "/t/p/w500"
        }
    }
    
    /*** Query parameters ***/
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .popularMovie(let language, let page), .topRatedMovie(let language, let page), .nowPlayingMovie(let language, let page):
                return ["language": language, "page": page]
            case .upcomingMovie(let language, let page, let region):
                return ["language": language, "page": page, "region": region]
            case .movieDetails(let movieID, let language):
                return ["movie_id": movieID, "language": language]
            case .movieListGenre(let language), .tvShowListGenre(let language):
                return ["language": language]
            case .movieFilterByGenre(let genreID, let language, let page), .tvShowFilterByGenre(let genreID, let language, let page):
                return ["genre_id": genreID, "language": language, "page": page]
            case .popularTvShow(let language, let page), .topRatedTvShow(let language, let page), .nowPlayingTvShow(let language, let page):
                return ["language": language, "page": page]
            case .tvShowDetails(let tvID, let language):
                return ["tv_id": tvID, "language": language]
            default:
                return [:]
            }
        }()
        
        let url = try MovieDatabaseRouter.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(MovieDatabaseRouter.authenticationToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
