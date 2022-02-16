//
//  LtkListViewModel.swift
//  LTK
//
//  Created by Alex Cruz on 2/13/22.
//

import Foundation
import PromiseKit

protocol LtkWVMProtocol {
    var datasource: [Ltk] { get }
    var currentPage: LtksWrapper? { get }
    func setCurrentPage(with data: LtksWrapper)
    func getCurrentPage(with featured: String, limit: Int, lastId: String?, seed: String?) -> Promise<LtksWrapper>
}

class LtkViewModel: LtkWVMProtocol {
    
    // ==================
    // MARK: - Properties
    // ==================
    
    // MARK: Injection
    var facade: LtkFacadeProtocol?
    init(facade: LtkFacadeProtocol) {
        self.facade = facade
    }
    
    // MARK: Private
    public var currentPage: LtksWrapper? {
        didSet {
            if oldValue != nil {
                guard let currentPage = currentPage else { return }
                datasource.append(contentsOf: currentPage.ltks)
            } else {
                guard let currentPage = currentPage else { return }
                datasource = currentPage.ltks
            }
        }
    }
    //
    public var datasource: [Ltk] = []
    
    
}

// ===============
// MARK: - Methods
// ===============
extension LtkViewModel {
    func setCurrentPage(with data: LtksWrapper) {
        self.currentPage = data
    }
    
}

// ==========================
// MARK: - Facade Interaction
// ==========================
extension LtkViewModel {
    func getCurrentPage(with featured: String, limit: Int, lastId: String? = nil, seed: String? = nil) -> Promise<LtksWrapper> {
        guard let facade = facade else { fatalError("Missing dependencies") }
        return facade.getCurrentPage(with: featured, limit: limit, lastId: lastId, seed: seed)
    }
}
