//
//  LtkFacade.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import PromiseKit

protocol LtkFacadeProtocol {
    func getCurrentPage(with featured: String, limit: Int, lastId: String?, seed: String?) -> Promise<LtksWrapper>
}

final class LtkFacade: LtkFacadeProtocol {
    // =============================
    // MARK: - Initializer injection
    // =============================
    let service: LtkServiceProtocol
    init(service: LtkServiceProtocol) {
        self.service = service
    }
}

// ========================
// MARK: - Service Requests
// ========================
extension LtkFacade {
    func getCurrentPage(with featured: String, limit: Int, lastId: String?, seed: String?) -> Promise<LtksWrapper> {
        service.getCurrentPage(with: featured, limit: limit, lastId: lastId, seed: seed)
    }
}
