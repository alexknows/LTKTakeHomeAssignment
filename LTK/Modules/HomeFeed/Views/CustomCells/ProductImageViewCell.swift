//
//  ProductImageViewCell.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit

class ProductImageViewCell: UITableViewCell {
    // =============
    // MARK: Outlets
    // =============
    
    // MARK: Image View
    @IBOutlet private weak var productImageView: UIImageView!

}

// =====================
// MARK: Table view cell
// =====================

// MARK: Life Cycle
extension ProductImageViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// ===============
// MARK: - Methods
// ===============
extension ProductImageViewCell {
    func setDataCell(with image: URL?) {
        productImageView.setImage(with: image)
    }
}

// ==================
// MARK: ReusableView
// ==================
extension ProductImageViewCell: ReusableView {}

// =====================
// MARK: NibLoadableView
// =====================
extension ProductImageViewCell: NibLoadableView {}

