//
//  LtkService.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import PromiseKit
import Moya

final class LtkService {
    // ============================
    // MARK: - Singleton Definition
    // ============================
    static let shared = LtkService()
    private init() {}
    
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
    func getLtkList(with featured: String, limit: Int) -> Promise<LtksWrapper> {
        return Promise<Data> { seal in
            // revisit
            provider.request(.ltks(featured: featured, limit: limit)) { result in
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


