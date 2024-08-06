//
//  EndPointType.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation
enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: [String: AnyCodable]? { get }
    var headers: [String: String]? { get }
}
