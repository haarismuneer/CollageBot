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
    
    func apiKeyword() -> String {
        return "top" + rawValue
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
                    if let allResults = serializedData?[type.apiKeyword()] as? [String: Any],
                       let content = allResults[type.displayableName()] as? [[String: Any]] {
                        if content.count == limit {
                            completion(NetworkResult.success(content))
                        } else {
                            completion(NetworkResult.failure(CollageBotError.incorrectCount))
                        }
                    } else {
                        completion(NetworkResult.failure(CollageBotError.genericError))
                    }
                } catch let error {
                    completion(NetworkResult.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    class func getAccountCreationDate(username: String, completion: @escaping (NetworkResult<String>) -> Void) {
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
                       let userDict = serializedData["user"] as? [String: Any],
                       let registeredDict = userDict["registered"] as? [String: Any],
                       let registeredTime = registeredDict["unixtime"] as? String {
                        completion(NetworkResult.success(registeredTime))
                    } else {
                        completion(NetworkResult.failure(CollageBotError.genericError))
                    }
                } catch let error {
                    completion(NetworkResult.failure(error))
                }
            }
        }
        task.resume()
    }
    
}
