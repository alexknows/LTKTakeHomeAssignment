//
//  GlobalError.swift
//  LTK
//
//  Created by Alex Cruz on 1/28/22.
//

import Foundation

enum GlobalError: Error, LocalizedError {
    case selfIsNil
    
    var errorDescription: String? {
        switch self {
        case .selfIsNil:
            return "Self is nil"
        }
    }
}
