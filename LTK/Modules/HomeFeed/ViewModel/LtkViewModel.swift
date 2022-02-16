//
//  LtkListViewModel.swift
//  LTK
//
//  Created by Alex Cruz on 2/13/22.
//

import Foundation
import PromiseKit

protocol LtkViewModelProtocol {
    var dataSource: [Ltk] { get }
    var currentPage: LtksWrapper? { get }
    func setCurrentPage(with data: LtksWrapper)
    func getCurrentPage(with featured: String, limit: Int, lastId: String?, seed: String?) -> Promise<LtksWrapper>
    func passingObject(currentPage: LtksWrapper, dataSource: [Ltk], indexPath: IndexPath) -> DetailModel
}

class LtkViewModel: LtkViewModelProtocol {
    
    // ==================
    // MARK: - Properties
    // ==================
    let avatarUrl: Box<URL?> = Box(nil)
    let heroImage: Box<URL?> = Box(nil)
    
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
                dataSource.append(contentsOf: currentPage.ltks)
            } else {
                guard let currentPage = currentPage else { return }
                dataSource = currentPage.ltks
            }
        }
    }
    //
    public var dataSource: [Ltk] = []
    
    
}

// ===============
// MARK: - Methods
// ===============
extension LtkViewModel {
    func setCurrentPage(with data: LtksWrapper) {
        self.currentPage = data
    }
    
    func passingObject(currentPage: LtksWrapper, dataSource: [Ltk], indexPath: IndexPath) -> DetailModel {
        var products: [Product?] = []
        dataSource[indexPath.row].productIds?.forEach { productID in
            products.append(currentPage.products.first { $0.id == productID } )
        }
        // TODO: Review
        // FIXME: Fix the forced bang
        self.heroImage.value = dataSource[indexPath.row].heroImage!
        self.avatarUrl.value = (currentPage.profiles.first { $0.id == dataSource[indexPath.row].profileId }?.avatarUrl!)!

        return DetailModel(heroImage: dataSource[indexPath.row].heroImage,
                                      avatarUrl: currentPage.profiles.first { $0.id == dataSource[indexPath.row].profileId }?.avatarUrl,
                                      products: products.compactMap { $0 } )
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
