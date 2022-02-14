//
//  LtkProvider.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation
import Moya

final class LtkProvider<Target: TargetType>: MoyaProvider<Target> {
    // ====================
    // MARK: - Initializers
    // ====================
    override init(endpointClosure: @escaping EndpointClosure = defaultEndpointMapping,
                  requestClosure: @escaping RequestClosure = defaultRequestMapping,
                  stubClosure: @escaping StubClosure = neverStub,
                  callbackQueue: DispatchQueue? = nil,
                  session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
                  plugins: [PluginType] = [],
                  trackInflights: Bool = false) {
        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
    
    @discardableResult
    override func request(_ target: Target,
                          callbackQueue: DispatchQueue? = .none,
                          progress: ProgressBlock? = .none,
                          completion: @escaping Completion) -> Cancellable {
        //
        return super.request(target, callbackQueue: callbackQueue, progress: progress) { [weak self] result in
            guard self != nil else {
                completion(result)
                return
            }
            //
            switch result {
            case .success:
                completion(result)
            case .failure(let error):
                let moyaError = error as MoyaError
                if case .underlying(_, let moyaResponse) = moyaError,
                    let response = moyaResponse, response.statusCode == 401 {
                    //
                } else {
                    completion(result)
                }
            }
        }
    }
}

