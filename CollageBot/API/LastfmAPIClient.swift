//
//  LastfmAPIClient.swift
//  CollageBot
//

import Foundation

enum NetworkResult<T> {
    case failure(Error)
    case success(T)
}

enum ContentType: String, CaseIterable {
    case artists
    case albums
    case tracks
    
    func displayableName() -> String {
        return String(self.rawValue.dropLast())
    }
}

class LastfmAPIClient {
    
    class func getTopContent(type: ContentType, username: String, timeframe: Timeframe, limit: Int, completion: @escaping (NetworkResult<[[String: Any]]>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://ws.audioscrobbler.com/2.0/") else { return }
        var query = "method=user.gettop\(type.rawValue)"
        query += "&user=\(username)&period=\(timeframe.rawValue)"
        query += "&limit=\(limit)&api_key=\(Secrets.lastFMKey)&format=json"
        urlComponents.query = query
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(NetworkResult.failure(error))
            } else if let data = data {
                do {
                    let serializedData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    if let allResults = serializedData?["topalbums"] as? [String: Any],
                    let albums = allResults["album"] as? [[String: Any]] {
                        if albums.count == limit {
                            completion(NetworkResult.success(albums))
                        } else {
//                            let incorrectCountError = Error()
//                            completion(NetworkResult.failure(incorrectCountError))
                        }
                    } else {
                        // TODO: handle error
                    }
                } catch let error {
                    completion(NetworkResult.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    class func getAccountCreationDate(username: String, completion: @escaping (NetworkResult<Int>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://ws.audioscrobbler.com/2.0/") else { return }
        urlComponents.query = "method=user.getinfo&user=\(username)&api_key=\(Secrets.lastFMKey)&format=json"
        
        guard let url = urlComponents.url else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(NetworkResult.failure(error))
            } else if let data = data {
                do {
                    if let serializedData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                    let registeredDict = serializedData["registered"] as? [String: Any],
                    let registeredTime = registeredDict["unixtime"] as? Int {
                        completion(NetworkResult.success(registeredTime))
                    } else {
                        // TODO: Handle error
                    }
                } catch let error {
                    completion(NetworkResult.failure(error))
                }
            }
        }
        task.resume()
    }
    
}
