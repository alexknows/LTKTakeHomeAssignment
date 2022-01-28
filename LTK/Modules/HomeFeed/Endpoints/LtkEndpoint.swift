//
//  LtkEndpoint.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import Moya

enum LtkEndpoint {
    case ltks(featured: String, limit: Int, lastId: String?, seed: String?)
}

extension LtkEndpoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: InfoDictionary.main.baseURL) else {
            fatalError("The URL must not be null.")
        }
        
        return url
    }
    
    var path: String {
        switch self {
        case .ltks:
            return "/ltks/"
        }
            
    }
    
    var method: Moya.Method {
        switch self {
        case .ltks:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .ltks(let featured, let limit, let lastId, let seed):
            var parameters: [String: Any] = ["featured": featured,
                                             "limit": limit]
            if let lastId = lastId, let seed = seed {
                parameters["last_id"] = lastId
                parameters["seed"] = seed
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
