//
//  ProductListParam.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation
struct ProductListParameter: Codable {
    var search: String? = ""
    let category_id: String
}
