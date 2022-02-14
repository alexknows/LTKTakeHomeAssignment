//
//  ProductViewController.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit
import SafariServices

final class ProductViewController: UIViewController {
    // ===============
    // MARK: - Outlets
    // ===============
    
    // MARK: Collection View
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            // Register collection view cell
            registerCollectionViewCell()
        }
    }
    
    // MARK: Image View
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.cornerRadius = profileImageView.frame.width / 2
        }
    }
    
    // ==================
    // MARK: - Properties
    // ==================
    
    // MARK: Public
    var detailModel: DetailModel?
    
    // MARK: Private
    private var products: [Product] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
}

// =======================
// MARK: - View Controller
// =======================

// MARK: Life Cycle
extension ProductViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
}

// ===============
// MARK: - Actions
// ===============
private extension ProductViewController {}

// ===============
// MARK: - Methods
// ===============
private extension ProductViewController {
    func registerCollectionViewCell() {
        collectionView.registerCell(ProductCollectionViewCell.self)
    }
    
    func setupView() {
        // What are you doing here?
        /**
         
        */
        products = detailModel?.products ?? []
        mainImageView.setImage(with: detailModel?.heroImage)
        profileImageView.setImage(with: detailModel?.avatarUrl)
    }
}

// =======================
// MARK: - Collection View
// =======================

// MARK: Data Source
extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.setContent(image: products[indexPath.row].imageUrl)
        return cell
    }
}

// MARK: Delegate
extension ProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = detailModel?.products?[indexPath.row].hyperlink  else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
}

// MARK: Delegate Flow Layout
extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3
        let height = width
        return CGSize(width: width, height: height)
    }
}
