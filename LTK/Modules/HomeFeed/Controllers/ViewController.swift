//
//  ViewController.swift
//  LTK
//
//  Created by Alex Cruz on 1/26/22.
//

import UIKit

class ViewController: UIViewController {
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
    var products = [Product]()
    
    // MARK: Public




}


// =======================
// MARK: - View Controller
// =======================

// MARK: Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let product = Product()
        product.image = URL(string: "url")
        products.append(product)
        print(products)
        // Do any additional setup after loading the view.
    }
}

// MARK: Navigation
extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let identifier = Segue(rawValue: segue.identifier ?? "") else { return }
        //
        switch identifier {
        case .showProduct:
            let destinationVC = segue.destination as? ProductViewController
            destinationVC?.product =  sender as? Product
        }
    }
}


// ===============
// MARK: - Methods
// ===============
private extension ViewController {
    func registerCollectionViewCell() {
        tableView.register(ProductImageViewCell.self)
    }
}

// ==================
// MARK: - Table View
// ==================

// MARK: Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductImageViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setDataCell(with: products[indexPath.row].image)
        
        return cell
    }
}

// MARK: Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.showProduct, sender: products[indexPath.row])
    }
}
