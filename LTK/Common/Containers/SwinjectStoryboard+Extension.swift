//
//  SwinjectStoryboard+Extension.swift
//  LTK
//
//  Created by Alex Cruz on 2/13/22.
//

import Foundation
import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
  @objc class func setup() {
    defaultContainer.autoregister(LtkServiceProtocol.self, initializer: LtkService.init)
    defaultContainer.autoregister(LtkFacadeProtocol.self, initializer: LtkFacade.init)
    defaultContainer.storyboardInitCompleted(LtkViewController.self) { resolver, controller in
      controller.facade = resolver ~> LtkFacadeProtocol.self
    }
  }
}
