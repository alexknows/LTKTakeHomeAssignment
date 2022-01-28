//
//  LtkViewController.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit
import PromiseKit

final class LtkViewController: UIViewController {
    // =============
    // MARK: - Enums
    // =============
    private enum Segue: String {
        case showProduct
    }
    
    // ===============
    // MARK: - Outlets
    // ===============
    
    // MARK: Table View
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Register collection view cell
            registerCollectionViewCell()
        }
    }
    
    // ==================
    // MARK: - Properties
    // ==================
    
    // MARK: Public
    
    // MARK: Private
    private var currentPage: LtksWrapper? {
        didSet {
            if oldValue != nil {
                guard let currentPage = currentPage else { return }
                datasource.append(contentsOf: currentPage.ltks)
            } else {
                guard let currentPage = currentPage else {
                    datasource = []
                    return
                }
                datasource = currentPage.ltks
            }
        }
    }
    private var datasource: [Ltk] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    private var isDataLoading = false
    
}


// =======================
// MARK: - View Controller
// =======================

// MARK: Life Cycle
extension LtkViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        
        showLoading()
            .then { [weak self] _ -> Promise<LtksWrapper> in
                guard let self = self else { return Promise(error: GlobalError.selfIsNil) }

                return self.getLtkList(with: "true", limit: 10)
            }
            .done(setCurrentPage)
            .ensure(hideLoading)
            .catch(presentError)
    }
}

// MARK: Navigation
extension LtkViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let identifier = Segue(rawValue: segue.identifier ?? "") else { return }
        
        switch identifier {
        case .showProduct:
            let destinationVC = segue.destination as? ProductViewController
            destinationVC?.detailModel =  sender as? DetailModel
        }
    }
}


// ===============
// MARK: - Methods
// ===============
private extension LtkViewController {
    func registerCollectionViewCell() {
        tableView.register(ProductImageViewCell.self)
    }
    
    func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setCurrentPage(with data: LtksWrapper) {
        currentPage = data
    }
    
}

// ==========================
// MARK: - Facade Interaction
// ==========================
private extension LtkViewController {
    func getLtkList(with featured: String, limit: Int, lastId: String? = nil, seed: String? = nil) -> Promise<LtksWrapper> {
        LtkFacade.shared.getLtkList(with: featured, limit: limit, lastId: lastId, seed: seed)
    }
}

// ==========================
// MARK: - View State Manager
// ==========================
private extension LtkViewController {
    func showLoading() -> Guarantee<Void> {
        tableView.showLoading()
        return Guarantee.value(())
    }
    
    func hideLoading() {
        tableView.hideLoading()
    }
}

// ==================
// MARK: - Table View
// ==================

// MARK: Data Source
extension LtkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductImageViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setDataCell(with: datasource[indexPath.row].heroImage)
        
        return cell
    }
}

// MARK: Delegate
extension LtkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.width
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var productImages: [Product?] = []
        datasource[indexPath.row].productIds?.forEach { productID in
            productImages.append(currentPage?.products.first { $0.id == productID } )
        }
        
        let detaiObject = DetailModel(heroImage: datasource[indexPath.row].heroImage,
                                      avatarUrl: currentPage?.profiles.first { $0.id == datasource[indexPath.row].profileId }?.avatarUrl,
                                      products: productImages.compactMap { $0 } )
        
        performSegue(withIdentifier: Segue.showProduct, sender: detaiObject)
    }
}

// ===================
// MARK: - Scroll View
// ===================
extension LtkViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        isDataLoading = false
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    // MARK: Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !isDataLoading{
                isDataLoading = true
                guard let lastId = currentPage?.meta.lastId,
                      let seed = currentPage?.meta.seed else { return }

                getLtkList(with: "true", limit: 10, lastId: lastId, seed: seed)
                    .done(setCurrentPage)
                    .ensure(hideLoading)
                    .catch(presentError)
            }
        }
    }
}
