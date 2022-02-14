//
//  LtkService.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import PromiseKit
import Moya

protocol LtkServiceProtocol {
    func getCurrentPage(with featured: String, limit: Int, lastId: String?, seed: String?) -> Promise<LtksWrapper>
}

final class LtkService: LtkServiceProtocol {
    // ==================
    // MARK: - Properties
    // ==================
    
    // MARK: Lazy
    private lazy var provider: LtkProvider<LtkEndpoint> = {
        let configuration = NetworkLoggerPlugin.Configuration(formatter: .init(),
                                                              output: NetworkLoggerPlugin.Configuration.defaultOutput,
                                                              logOptions: [.formatRequestAscURL, .verbose])
        let networkLoggerPlugin = NetworkLoggerPlugin(configuration: configuration)
        
        return LtkProvider<LtkEndpoint>(plugins: [networkLoggerPlugin])
    }()
}

// ===============
// MARK: - Methods
// ===============
extension LtkService {
    func getCurrentPage(with featured: String, limit: Int, lastId: String?, seed: String?) -> Promise<LtksWrapper> {
        return Promise<Data> { seal in
            provider.request(.ltks(featured: featured, limit: limit, lastId: lastId, seed: seed)) { result in
                switch result {
                case let .success(moyaResponse):
                    let data = moyaResponse.data
                    seal.fulfill(data)
                case let .failure(error):
                    seal.reject(error)
                }
            }
        }
        .then(LtksWrapper.jsonDecode)
        .recover(NetworkErrors.handle)
    }
}
