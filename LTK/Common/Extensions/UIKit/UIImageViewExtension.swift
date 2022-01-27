//
//  UIImageViewExtension.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit
import Kingfisher

typealias CompletionHandler = (Result<RetrieveImageResult, KingfisherError>) -> Void

extension UIImageView {
    @discardableResult
    func setImage(with resource: Resource?,
                  placeholder: Placeholder? = nil,
                  options: KingfisherOptionsInfo? = nil,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: CompletionHandler? = nil) -> DownloadTask? {
        return kf.setImage(with: resource,
                           placeholder: placeholder,
                           options: options,
                           progressBlock: progressBlock,
                           completionHandler: completionHandler)
    }
}
