//
//  UITableViewExtension.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit

extension UITableView {
    /// Registers tableViewCell with dynamic nib and identifier
    ///
    /// - Parameter cellType: tableView cell
    func register<CellType: UITableViewCell>(_ cellType: CellType.Type) where CellType: NibLoadableView, CellType: ReusableView {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    /// Registers headerFooterView with dynamic nib and identifier
    ///
    /// - Parameter headerFooterType: UITableViewHeaderFooterView
    func register<HeaderFooterType: UITableViewHeaderFooterView>(_ headerFooterType: HeaderFooterType.Type) where HeaderFooterType: NibLoadableView, HeaderFooterType: ReusableView {
        register(headerFooterType.nib,
                 forHeaderFooterViewReuseIdentifier: headerFooterType.reuseIdentifier)
    }
    
    /// Dequeues UITableViewCell based on the dynamic identifier
    ///
    /// - Parameter indexPath: cell indexpath
    /// - Returns: UITableViewCell
    func dequeueReusableCell<CellType: UITableViewCell>(for indexPath: IndexPath) -> CellType where CellType: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: CellType.reuseIdentifier,
                                             for: indexPath) as? CellType else {
                                                fatalError("could not dequeue cell with identifier: " + CellType.reuseIdentifier)
        }
        return cell
    }
    
    /// Dequeues tableViewHeaderFooterView based on the dynamic identifier
    ///
    /// - Returns: UITableViewHeaderFooterView
    func dequeueReusableHeaderFooterView<HeaderFooterType: UITableViewHeaderFooterView>() -> HeaderFooterType where HeaderFooterType: ReusableView {
        guard let view =  dequeueReusableHeaderFooterView(withIdentifier: HeaderFooterType.reuseIdentifier) as? HeaderFooterType else {
            fatalError("could not dequeue HeaderFooterView with identifier: " + HeaderFooterType.reuseIdentifier)
        }
        return view
    }
    
}
