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

enum Result<T> {
    case failure(Error)
    case success(T)
}

class LastfmAPIClient {
    
    class func getTopAlbums(username: String, timeframe: Timeframe, completion: @escaping (Result<[[String: Any]]>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://ws.audioscrobbler.com/2.0/") else { return }
        urlComponents.query = "method=user.gettopalbums&user=\(username)&period=\(timeframe.rawValue)&api_key=\(Secrets.lastFMKey)&format=json"
        
        guard let url = urlComponents.url else { return }
        
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(Result.failure(error))
            } else if let data = data {
                do {
                    let serializedData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    if let allResults = serializedData?["topalbums"] as? [String: Any],
                    let albums = allResults["album"] as? [[String: Any]] {
                        completion(Result.success(albums))
                    }
                } catch let error {
                    completion(Result.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}

extension Date {
    
    func getDateStringBeforeInterval(_ timeframe: Timeframe) -> String {
        // TODO: create result enum
        
        var component: Calendar.Component
        var value = 0
        
        switch timeframe {
        case .oneWeek:
            component = .weekOfYear
            value = -1
        case .oneMonth:
            component = .month
            value = -1
        case .threeMonths:
            component = .month
            value = -3
        case .sixMonths:
            component = .month
            value = -6
        case .twelveMonths:
            component = .year
            value = -1
        default:
            return ""
        }
        
        guard let previousDate = Calendar.current.date(byAdding: component, value: value, to: self) else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: previousDate)
    }
    
}
