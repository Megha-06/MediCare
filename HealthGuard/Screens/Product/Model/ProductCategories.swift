//
//  Product Categories.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation
struct Product: Codable {
    let response_code: Int
    let message: String
    let response: [ProductData]
  
}
struct ProductData: Codable {
    let id: String
    let category_name: String
    let category_image : String
    let status : String

}
