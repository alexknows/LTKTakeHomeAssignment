//
//  ReusableViewExtension.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
