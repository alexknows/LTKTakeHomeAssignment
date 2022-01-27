//
//  DictionaryExtension.swift
//  LTK
//
//  Created by Alex Cruz on 1/27/22.
//

import Foundation

extension Dictionary {
    /// Concatenates two dictionries together
    ///
    /// - Parameters:
    ///   - lhs: First dictionary
    ///   - rhs: Second dictionary
    static func += (lhs: inout Dictionary, rhs: Dictionary) {
        lhs.merge(rhs) { (_, value) -> Value in
            return value
        }
    }
}

// ===============================================
// MARK: - value and valueIfPresent methods
// ===============================================

// MARK: General
extension Dictionary {
    /// Returns value for given key casted to desired value type.
    ///
    /// **Note:** This method will crash, if it can not find or cast the value.
    ///
    /// - Parameter key: Desired key to find and cast associated value
    /// - Returns: Casted value associated to given key
    func value<ValueType>(forKey key: Key) -> ValueType {
        guard let rawValue = self[key] else {
            fatalError("Could not find value for key \(key)")
        }
        
        guard let value = rawValue as? ValueType else {
            fatalError("Could not cast value for key \(key) to type \(ValueType.self)")
        }
        
        return value
    }
    
    /// Returns value for given key casted to desired value type.
    ///
    /// **Note:** This method will return nil, if it can not find or cast the value.
    ///
    /// - Parameter key: Desired key to find and cast associated value
    /// - Returns: Casted value associated to given key or nil
    func valueIfPresent<ValueType>(forKey key: Key) -> ValueType? {
        return self[key] as? ValueType
    }
    
}

// MARK: RawRepresentable
extension Dictionary {
    /// Return value for given key casted to desired value type.
    ///
    /// **Notes:**
    ///   - This methods only works for RawRepresentable types
    ///   - This method will crash, if it can not find or cast the value
    ///
    /// - Parameter key: Desired key to find and cast associated value
    /// - Returns: Casted value associated to given key
    func value<KeyType: RawRepresentable, ValueType>(forKey key: KeyType) -> ValueType where KeyType.RawValue == Key {
        return value(forKey: key.rawValue)
    }
    
    /// Returns value for given key casted to desired value type.
    ///
    /// **Notes:**
    ///   - This methods only works for RawRepresentable types
    ///   - This method will return nil, if it can not find or cast the value
    ///
    /// - Parameter key: Desired key to find and cast associated value
    /// - Returns: Casted value associated to given key or nil
    func valueIfPresent<KeyType: RawRepresentable, ValueType>(forKey key: KeyType) -> ValueType? where KeyType.RawValue == Key {
        return valueIfPresent(forKey: key.rawValue)
    }
    
    subscript<KeyType: RawRepresentable, ValueType>(_ key: KeyType) -> ValueType where KeyType.RawValue == Key {
        get {
            return value(forKey: key)
        }
        set {
            guard let value = newValue as? Value else {
                fatalError("Could not cast new value \(newValue) to type \(Value.self)")
            }
            
            self[key.rawValue] = value
        }
    }
}
