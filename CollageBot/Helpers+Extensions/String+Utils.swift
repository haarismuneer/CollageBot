//
//  String+Utils.swift
//  CollageBot
//

import Foundation

extension String {
    
    func isValidUsername(_ completion: @escaping((Bool) -> Void)) {
        guard !isEmpty && !containsInvalidCharacters() else {
            completion(false)
            return
        }
        
        LastfmAPIClient.getAccountCreationDate(username: self) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func containsInvalidCharacters() -> Bool {
        return false
    }
    
}
