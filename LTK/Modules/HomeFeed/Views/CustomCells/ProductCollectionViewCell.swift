//
//  ProductCollectionViewCell.swift
//  LTK
//
//  Created by Alex Cruz on 1/27/22.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    // =============
    // MARK: Outlets
    // =============
    
    // MARK: Image View
    @IBOutlet private weak var productImageView: UIImageView! {
        didSet {
            productImageView.cornerRadius = 5.0
        }
    }
    

}

// ==========================
// MARK: Collection View Cell
// ==========================

// MARK: Life Cycle
extension ProductCollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //
        productImageView.image = nil
    }
}

// ===============
// MARK: - Methods
// ===============

// MARK: Public
extension ProductCollectionViewCell {
    func setContent(image: URL?) {
        productImageView.setImage(with: image)
    }
}

// ==================
// MARK: ReusableView
// ==================
extension ProductCollectionViewCell: ReusableView {}

// =====================
// MARK: NibLoadableView
// =====================
extension ProductCollectionViewCell: NibLoadableView {}
