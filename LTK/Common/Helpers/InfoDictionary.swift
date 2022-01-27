//
//  InfoDictionary.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation

final class InfoDictionary {
    // =============
    // MARK: - Enums
    // =============
    private enum InfoDictionaryKey: String {
        case baseURL = "Base URL"
    }
    
    // ==================
    // MARK: - Properties
    // ==================
    
    // MARK: Instance
    private let dictionary: [String: Any]!
    
    // MARK: Static
    static private(set) var main = InfoDictionary(Bundle.main.infoDictionary)
    
    init(_ dictionary: [String: Any]!) {
        self.dictionary = dictionary
    }
    
    // ==============
    // MARK: - Fields
    // ==============
    
    // MARK: Base URL
    lazy private(set) var baseURL: String = dictionary[InfoDictionaryKey.baseURL]
}

