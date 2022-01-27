//
//  Page.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation

protocol Paginatable {
    static var pluralName: String { get }
}

struct Page<ModelType>: Decodable where ModelType: Decodable, ModelType: Paginatable {
    // =============
    // MARK: - Enums
    // =============
    struct DynamicKey: CodingKey {
        // MARK: Properties
        var stringValue: String
        var intValue: Int?
        
        // MARK: String Initializer
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        // MARK: Int Initializer
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = intValue.description
        }
        
        static var data: DynamicKey {
            guard let key = DynamicKey(stringValue: ModelType.pluralName) else {
                fatalError("Could not create Root Coding Key with value \"\(ModelType.pluralName)\"")
            }
            return key
        }
        
    }
    private enum CodingKeys: String, CodingKey {
        case currentPage, nextPage, pageLimit
    }
    
    // ==================
    // MARK: - Properties
    // ==================
    var ltks: [ModelType]
    var currentPage: Int?
    var nextPage: Int?
    var pageLimit: Int?
    
    // ====================
    // MARK: - Initializers
    // ====================
    init(from decoder: Decoder) throws {
        // Creating Containers
        let rootContainer = try decoder.container(keyedBy: DynamicKey.self)
        let paginationContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decoding Data
        ltks = try rootContainer.decode([ModelType].self, forKey: .data)
        
        // Decoding Pagination Meta Data
        currentPage = try paginationContainer.decodeIfPresent(Int.self, forKey: .currentPage)
        nextPage = try paginationContainer.decodeIfPresent(Int.self, forKey: .nextPage)
        pageLimit = try paginationContainer.decodeIfPresent(Int.self, forKey: .pageLimit)
    }
}

