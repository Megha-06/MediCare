//
//  ProductListingVC.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import UIKit

class ProductListingVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblProductListing: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    // MARK: - Variables
    private var viewModel = ProductViewModel()
    var selectedCategory : String?
    var selectedCategoryId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Data Management
extension ProductListingVC{
    func configuration() {
        let categories = UINib(nibName: "ProductListingTableCell" , bundle: nil)
        self.tblProductListing.register(categories, forCellReuseIdentifier: "ProductListingTableCell")
        lblHeading.text = "\(selectedCategory ?? "")"
        lblCategoryName.text = "Explore Our \(selectedCategory ?? "")"
        initViewModel()
        observeEvent()
    }
    func initViewModel() {
        let parameters = ProductListParameter(search: "", category_id: selectedCategoryId ?? "")
        viewModel.fetchProductsList(parameters: parameters)
    }
    func observeEvent() {
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .loading:
                /// Indicator show
                self.showActivityIndicator()
                print("Product loading....")
            case .stopLoading:
                // Indicator hide
                print("Stop loading...")
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    // UI Main works well
                    self.tblProductListing.reloadData()
                }
            case .error(let error):
                print(error)
            case .ProductList(product: let product):
                print("")
            }
        }
    }
}

// MARK: - Table Datasource & Delegate
extension ProductListingVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productsList?.response.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = tableView.dequeueReusableCell(withIdentifier: "ProductListingTableCell") as! ProductListingTableCell
        let dict = viewModel.productsList?.response[indexPath.row]
        category.lblCategoryName.text = dict?.product_name
        category.lblDescription.text = dict?.extra_info
        category.lblPrice.text = dict?.price
        return category
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
