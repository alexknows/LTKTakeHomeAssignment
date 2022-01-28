//
//  UICollectionViewExtension.swift
//  LTK
//
//  Created by Alex Cruz on 1/27/22.
//

import UIKit

extension UICollectionView {
    /// Registers collectionViewCell with dynamic nib and identifier
    ///
    /// - Parameter cellType: collectionView cell
    func registerCell<CellType: UICollectionViewCell>(_ cellType: CellType.Type) where CellType: NibLoadableView, CellType: ReusableView {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    /// Registers collectionViewHeader with dynamic nib and identifier
    ///
    /// - Parameter headerType: UICollectionReusableView
    func registerHeader<HeaderType: UICollectionReusableView>(_ headerType: HeaderType.Type) where HeaderType: NibLoadableView, HeaderType: ReusableView {
        register(headerType.nib,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: headerType.reuseIdentifier)
    }
    
    /// Registers collectionViewFooter with dynamic nib and identifier
    ///
    /// - Parameter footerType: UICollectionReusableView
    func registerFooter<FooterType: UICollectionReusableView>(_ footerType: FooterType.Type) where FooterType: NibLoadableView, FooterType: ReusableView {
        register(footerType.nib,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: footerType.reuseIdentifier)
    }
    
    /// Dequeues collectionViewCell based on the dynamic identifier
    ///
    /// - Parameter indexPath: cell indexpath
    /// - Returns: UICollectionViewCell
    func dequeueReusableCell<CellType: UICollectionViewCell>(for indexPath: IndexPath) -> CellType where CellType: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CellType.reuseIdentifier, for: indexPath) as? CellType
            else {
                fatalError("could not dequeue cell with identifier: " + CellType.reuseIdentifier)
        }
        return cell
    }
    
    /// Dequeues collectionViewHeader based on the dynamic identifier
    ///
    /// - Parameter indexPath: desire indexpath
    /// - Returns: UICollectionReusableView
    func dequeueReusableHeader<HeaderType: UICollectionReusableView>(for indexPath: IndexPath) -> HeaderType where HeaderType: ReusableView {
        guard let header = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                            withReuseIdentifier: HeaderType.reuseIdentifier,
                                                            for: indexPath) as? HeaderType
            else {
                fatalError("could not dequeue header with identifier: " + HeaderType.reuseIdentifier)
        }
        return header
    }
    
    /// Dequeues collectionViewFooter based on the dynamic identifier
    ///
    /// - Parameter indexPath: desire indexpath
    /// - Returns: UICollectionReusableView
    func dequeueReusableFooter<FooterType: UICollectionReusableView>(for indexPath: IndexPath) -> FooterType where FooterType: ReusableView {
        guard let footer = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                            withReuseIdentifier: FooterType.reuseIdentifier,
                                                            for: indexPath) as? FooterType
            else {
                fatalError("could not dequeue footer with identifier: " + FooterType.reuseIdentifier)
        }
        return footer
    }
    
}
