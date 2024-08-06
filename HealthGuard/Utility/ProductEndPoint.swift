//
//  ProductEndPoint.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation
enum ProductEndPoint {
    case productsCategories
    case productsListing(product: ProductListParameter)
}

extension ProductEndPoint: EndPointType {
    var path: String {
        switch self {
        case .productsCategories:
            return "MedicalProduct/category_list/format/json"
        case .productsListing:
            return "Admin_Medical_product_api/search_new_product_section/format/json"
        }
    }       
    
    var baseURL: String {
       return "http://13.235.159.69/vesta/api/"
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
            return .post
    }
    
    var body: [String : AnyCodable]? {
        switch self {
        case .productsCategories:
            return nil
        case .productsListing(let product):
            return ["category": AnyCodable(product.category_id)]
        }
    }

    var headers: [String : String]? {
        switch self {
        case .productsCategories:
            return APIManager.categoriesHeaders
        case .productsListing:
            return APIManager.productListHeaders
        }
        
    }
}
