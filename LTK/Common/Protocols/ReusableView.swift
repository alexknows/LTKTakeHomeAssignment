//
//  ReusableView.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import Foundation

protocol ReusableView {
    /// Reuse identifier of this view
    static var reuseIdentifier: String { get }
}

