//
//  ProductViewModel.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation
final class ProductViewModel {
    
    var products: Product?
    var productsList : ProductList?
    var eventHandler: ((_ event: Event) -> Void)? // Data Binding Closure
    
    func fetchProducts() {
        self.eventHandler?(.loading)
        APIManager.shared.request(
            modelType: Product.self,
            type: ProductEndPoint.productsCategories, parameters: nil) { response in
                self.eventHandler?(.stopLoading)
                switch response {
                case .success(let products):
                    self.products = products
                    self.eventHandler?(.dataLoaded)
                case .failure(let error):
                    self.eventHandler?(.error(error))
                }
            }
    }
    func fetchProductsList(parameters: ProductListParameter) {
        let parameters = ProductListParameter(category_id: "Electronics")
        
        APIManager.shared.request(
            modelType: ProductList.self,
            type: ProductEndPoint.productsListing(product: parameters)
        ) { result in
            switch result {
            case .success(let response):
                self.productsList =  response
                self.eventHandler?(.dataLoaded)
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ProductViewModel {
    
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
        case ProductList(product: ProductListParameter)
    }
}
