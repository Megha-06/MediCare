//
//  ProductListingModel.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation

struct ProductList: Codable {
    let response_code: Int
    let message: String
    let response: [ProductListData]
}
struct ProductListData: Codable {
    let category_name: String
    let product_name: String
    let indication: String
    let category : String
    let extra_info : String
    let product_id : String
    let price : String
    let final_price : String
}
