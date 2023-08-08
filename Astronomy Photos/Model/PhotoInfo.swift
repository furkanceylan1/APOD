//
//  PhotoInfo.swift
//  Astronomy Photos
//
//  Created by Furkan Ceylan on 3.08.2023.
//

import Foundation
import UIKit

struct PhotoInfo: Codable, Equatable {
    var title: String
    var url: URL?
    var description: String // explanation
    var date: String
    var hdUrl: URL?
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        
        case title, url, date, copyright
        case description = "explanation"
        case hdUrl = "hdurl"
    }
    
    static func ==(lhs: PhotoInfo, rhs: PhotoInfo) -> Bool {
        return lhs.date == rhs.date
    }
}
