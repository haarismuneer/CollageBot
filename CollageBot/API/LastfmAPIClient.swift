//
//  LastfmAPIClient.swift
//  CollageBot
//

import Foundation

enum Timeframe: String {
    case overall
    case oneWeek = "7day"
    case oneMonth = "1month"
    case threeMonths = "3month"
    case sixMonths = "6month"
    case twelveMonths = "12month"
}

enum NetworkResult<T> {
    case failure(Error)
    case success(T)
}

class LastfmAPIClient {
    
    class func getTopAlbums(username: String, timeframe: Timeframe, limit: Int, completion: @escaping (NetworkResult<[[String: Any]]>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://ws.audioscrobbler.com/2.0/") else { return }
        urlComponents.query = "method=user.gettopalbums&user=\(username)&period=\(timeframe.rawValue)&limit=\(limit)&api_key=\(Secrets.lastFMKey)&format=json"
        
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
                        completion(NetworkResult.success(albums))
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
