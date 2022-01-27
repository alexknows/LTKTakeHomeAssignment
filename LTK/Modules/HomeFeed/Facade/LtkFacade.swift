//
//  LtkFacade.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import PromiseKit


final class LtkFacade {
    // ============================
    // MARK: - Singleton Definition
    // ============================
    static let shared = LtkFacade()
    private init() {}
    
    // ================
    // MARK: - Services
    // ================
    private let ltkService = LtkService.shared
}

// ========================
// MARK: - Service Requests
// ========================
extension LtkFacade {
    func getLtkList(with featured: String, limit: Int) -> Promise<LtksWrapper> {
        ltkService.getLtkList(with: featured, limit: limit)
            .map { $0.self }
    }
}
