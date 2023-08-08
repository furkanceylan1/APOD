//
//  NetworkController.swift
//  Astronomy Photos
//
//  Created by Furkan Ceylan on 3.08.2023.
//

import Foundation
import UIKit

struct NetworkController {
    
    func fetchPhotoInfo(query: [String: String], completion: @escaping (Result<PhotoInfo?, Error>) -> Void) {
        
        let baseUrl: URL = URL(string: "https://api.nasa.gov/planetary/apod")!
        guard let apodUrl = baseUrl.withQuery(with: query, url: baseUrl) else { return }
        
        let jsonDecoder = JSONDecoder()
        
        URLSession.shared.dataTask(with: apodUrl) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }else if let data = data {
                do{
                    var photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
                    completion(.success(photoInfo))
                }catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func fetchPhoto(from url: URL, completion: @escaping (UIImage?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }else {
                completion(nil)
            }
        }.resume()
    }
}
