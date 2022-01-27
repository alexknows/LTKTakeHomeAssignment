//
//  ProductViewController.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit

class ProductViewController: UIViewController {
    // ==================
    // MARK: - Properties
    // ==================
    
    // MARK: Public
    var ltk: Ltk!
    var ltksWrapper: LtksWrapper!
    
    // MARK: Image View
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    
}

// =======================
// MARK: - View Controller
// =======================

// MARK: Life Cycle
extension ProductViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainImageView.setImage(with: ltk.heroImage)
        
        for profile in ltksWrapper.profiles {
            if profile.id == ltk.profileId {
                profileImageView.setImage(with: profile.avatarUrl)
            }
        }
        
    }
    
}
