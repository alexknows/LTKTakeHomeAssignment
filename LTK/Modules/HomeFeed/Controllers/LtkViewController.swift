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

    // MARK: Table View
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            // Register table view cell
            registerTableViewCell()
        }
    }
    
    // ==================
    // MARK: - Properties
    // ==================
    
    // MARK: Injection
    var viewModel: LtkViewModelProtocol?

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
                guard let self = self else { return Promise(error: GlobalError.selfIsNil)}
                return (self.viewModel?.getCurrentPage(with: "true", limit: 10, lastId: "", seed: ""))!
            }
            .done(self.viewModel!.setCurrentPage)
            .ensure(showView)
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
            destinationVC?.ltkViewModel = self.viewModel as? LtkViewModel
        }
    }
}

// ===============
// MARK: - Methods
// ===============
private extension LtkViewController {
    func registerTableViewCell() {
        tableView.register(ProductImageViewCell.self)
    }
    
    func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func reload() {
        tableView.reloadData()
    }
}

// ==========================
// MARK: - View State Manager
// ==========================
private extension LtkViewController {
    func showLoading() -> Guarantee<Void> {
        tableView.showLoading()
        return .value(())
    }
    
    func showView() {
        tableView.reloadData()
        tableView.hideLoading()
    }
}

// ==================
// MARK: - Table View
// ==================

// MARK: Data Source
extension LtkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductImageViewCell = tableView.dequeueReusableCell(for: indexPath)
        let ltkViewModel = self.viewModel?.dataSource[indexPath.row]
        cell.ltkViewModel = ltkViewModel
        return cell
        
    }
}

// MARK: Delegate
extension LtkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.width
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unwrapped_currentPage = self.viewModel?.currentPage else { return }
        guard let unwrapped_datasource = self.viewModel?.dataSource else { return }
        self.viewModel?.passingObject(currentPage: unwrapped_currentPage,
                                                         dataSource: unwrapped_datasource,
                                                         indexPath: indexPath)
        performSegue(withIdentifier: Segue.showProduct, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 >= self.viewModel?.dataSource.count ?? 0 {
            guard let lastId = self.viewModel?.currentPage?.meta.lastId,
                  let seed = self.viewModel?.currentPage?.meta.seed else { return }

            self.viewModel?.getCurrentPage(with: "true", limit: 10, lastId: lastId, seed: seed)
                .done(self.viewModel!.setCurrentPage)
                .ensure(showView)
                .catch(presentError)
        }
    }
}

// ===================
// MARK: - Scroll View
// ===================
//extension LtkViewController {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
//        isDataLoading = false
//    }
//
//
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
//    }
//
//    // MARK: Pagination
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
//        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
//        {
//            if !isDataLoading{
//                isDataLoading = true
//                guard let lastId = currentPage?.meta.lastId,
//                      let seed = currentPage?.meta.seed else { return }
//
//                getCurrentPage(with: "true", limit: 10, lastId: lastId, seed: seed)
//                    .done(setCurrentPage)
//                    .ensure(hideLoading)
//                    .catch(presentError)
//            }
//        }
//    }
//}

