//
//  Playlist.swift
//  spotifyTutorial
//
//  Created by Daniel Thompson on 7/24/17.
//  Copyright © 2017 Daniel Thompson. All rights reserved.
//

import Foundation

class Playlist {
    
    // !!! potentially replaced with SDK code....
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let baseURL = URL(string: "https://api.spotify.com/v1/")!
    
    static let session = URLSession.shared
    
    
    
    // SHARED REQUEST CODE ::::::::::::::::::::::::::::::
    
    static func makeRequest( request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void ){
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
    
    static func attachParameters( url: URL, params: [String: String] ) -> URLRequest {
        
        var queryURLComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        var queryItems = [URLQueryItem]()
        for (key,value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        queryItems = queryItems.filter{ !$0.name.isEmpty }

        if !queryItems.isEmpty {
            queryURLComponents?.queryItems = queryItems
        }
        
        let request = URLRequest( url: (queryURLComponents?.url)! )

        return request
    }
    
    
    
    // INDIVIDUAL QUERY CODE ::::::::::::::::::::::::::::::
    
    static func getListOfFeaturedPlaylists( params: [String: String], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void ){
        
        let featuredPlaylistURL = URL(string: "browse/featured-playlists", relativeTo: baseURL)!
        let queryURLRequest = attachParameters(url: featuredPlaylistURL, params: params)
        
        makeRequest(request: queryURLRequest, completionHandler: completionHandler)
        
    }
    
}
