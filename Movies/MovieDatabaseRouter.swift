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
    
    /*** Movie ***/
    case popularMovie(language: String, page: Int)                  //Get the popular movie
    case upcomingMovie(language: String, page: Int, region: String) //Get the upcoming movie
    case topRatedMovie(language: String, page: Int)                 //Get the top rated movie
    case nowPlayingMovie(language: String, page: Int)               //Get the movie playing now
    case movieDetails(id: Int, language: String)                    //Get the details of a specific movie
    case movieTrailer(id: Int, language: String)                    //Get the trailer of the movie
    case searchMovie(language: String, query: String, page: Int)    //Get the movies which corresponds to the query
    
    /*** TV Show ***/
    case popularTvShow(language: String, page: Int)                 //Get the popular TV show
    case nowPlayingTvShow(language: String, page: Int)              //Get the TV show playing now
    case topRatedTvShow(language: String, page: Int)                //Get the top rated TV show
    case tvShowDetails(id: Int, language: String)                   //Get the details of a specific TV show
    case tvShowTrailer(id: Int, language: String)                    //Get the trailer of the movie
    case searchTvShow(language: String, query: String, page: Int)    //Get the TV shows which corresponds to the query
    
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
        case .movieDetails(let id, _):
            return "/3/movie/" + String(id)
        case .movieTrailer(let id, _):
            return "/3/movie/" + String(id) + "/videos"
        case .searchMovie:
            return "/3/search/movie"
        case .popularTvShow:
            return "/3/tv/popular"
        case .nowPlayingTvShow:
            return "/3/tv/on_the_air"
        case .topRatedTvShow:
            return "/3/tv/top_rated"
        case .tvShowDetails(let id, _):
            return "/3/tv/" + String(id)
        case .tvShowTrailer(let id, _):
            return "/3/tv/" + String(id) + "/videos"
        case .searchTvShow:
            return "/3/search/tv"
        }
    }
    
    /*** Query parameters ***/
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .popularMovie(let language, let page), .topRatedMovie(let language, let page), .nowPlayingMovie(let language, let page):
                return ["api_key": "332db8037d480cad9ce169f33c51f34a", "language": language, "page": page]
            case .upcomingMovie(let language, let page, let region):
                return ["api_key": "332db8037d480cad9ce169f33c51f34a", "language": language, "page": page, "region": region]
            case .movieDetails(let language), .movieTrailer(let language), .tvShowDetails(let language), .tvShowTrailer(let language):
                return ["api_key": "332db8037d480cad9ce169f33c51f34a", "language": language]
            case .popularTvShow(let language, let page), .topRatedTvShow(let language, let page), .nowPlayingTvShow(let language, let page):
                return ["api_key": "332db8037d480cad9ce169f33c51f34a", "language": language, "page": page]
            case .searchMovie(let language, let query, let page), .searchTvShow(let language, let query, let page):
                return ["api_key": "332db8037d480cad9ce169f33c51f34a", "language": language, "query": query, "page": page]
            }
        }()
        
        let url = try MovieDatabaseRouter.baseURLPath.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
