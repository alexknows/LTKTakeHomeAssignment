//
//  LtkViewController.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit
import PromiseKit

class LtkViewController: UIViewController {
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
    var ltksWrapper: LtksWrapper?
    
    // MARK: Public
    
    
    // MARK: Private
    private var ltksArray: [Ltk] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

}


// =======================
// MARK: - View Controller
// =======================

// MARK: Life Cycle
extension LtkViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        showLoading()
            .then(getLtkList)
            .done(setLtkList)
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
        //
        switch identifier {
        case .showProduct:
            let destinationVC = segue.destination as? ProductViewController
            destinationVC?.ltk =  sender as? Ltk
            destinationVC?.ltksWrapper = ltksWrapper
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
    
    func setLtkList(with data: LtksWrapper) {
        ltksWrapper = data
        ltksArray = data.ltks
    }
    
    func setNextLtkList(with data: LtksWrapper) {
        ltksWrapper = data
        ltksArray.append(contentsOf: data.ltks)
    }
    
}

// ==========================
// MARK: - Facade Interaction
// ==========================
private extension LtkViewController {
    func getLtkList() -> Promise<LtksWrapper> {
        LtkFacade.shared.getLtkList(with: "true", limit: 5)
    }
    
    func getNextLtkList() -> Promise<LtksWrapper> {
        LtkFacade.shared.getNextLtkList(with: "true", lastId: ltksWrapper?.meta.lastId ?? "", limit: ltksWrapper?.meta.limit ?? 0, seed: ltksWrapper?.meta.seed ?? "")
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
        return ltksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductImageViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setDataCell(with: ltksArray[indexPath.row].heroImage)
        
        return cell
    }
}

// MARK: Delegate
extension LtkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: Segue.showProduct, sender: ltksArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 >= ltksArray.count {
            getNextLtkList()
                .done(setNextLtkList)
                .catch(presentError)
        }
    }
}
