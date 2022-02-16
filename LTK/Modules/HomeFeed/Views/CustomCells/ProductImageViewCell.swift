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
    
    
    var ltkViewModel: Ltk! {
        didSet {
            productImageView.setImage(with: ltkViewModel.heroImage)
        }
    }

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

// ==================
// MARK: ReusableView
// ==================
extension ProductImageViewCell: ReusableView {}

// =====================
// MARK: NibLoadableView
// =====================
extension ProductImageViewCell: NibLoadableView {}

