//
//  LtkEndpoint.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import Moya

enum LtkEndpoint {
    case ltks(featured: String, limit: Int)
    case ltksNextPage(featured: String, lastId: String, limit: Int, seed: String)
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
        case .ltks(_, _):
            return "/ltks/"
        case .ltksNextPage(_,_,_, _):
            return "/ltks/"
        }
            
    }
    
    var method: Moya.Method {
        switch self {
        case .ltks, .ltksNextPage:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .ltks(let featured, let limit):
            let parameters: [String: Any] = ["featured": featured, "limit": limit]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .ltksNextPage(featured: let featured, lastId: let lastId, limit: let limit, seed: let seed):
            let parameters: [String: Any] = ["featured": featured, "last_id": lastId, "limit": limit, "seed": seed]
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
