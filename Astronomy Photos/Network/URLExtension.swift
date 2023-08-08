//
//  URLExtension.swift
//  Astronomy Photos
//
//  Created by Furkan Ceylan on 3.08.2023.
//

import Foundation

extension URL {
    
    func withQuery(with query: [String: String], url: URL) -> URL? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = query.map({URLQueryItem(name: $0.0, value: $0.1)})
        
        return components?.url
    }
}
