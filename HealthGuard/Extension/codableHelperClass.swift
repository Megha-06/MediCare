//
//  codableHelperClass.swift
//  HealthGuard
//
//  Created by Megha Singh on 06/08/24.
//

import Foundation

struct AnyCodable: Codable {
    let value: Any

    init<T>(_ value: T?) {
        self.value = value ?? ()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(Bool.self) {
            self.value = value
        } else if let value = try? container.decode(Int.self) {
            self.value = value
        } else if let value = try? container.decode(Double.self) {
            self.value = value
        } else if let value = try? container.decode(String.self) {
            self.value = value
        } else if let value = try? container.decode([AnyCodable].self) {
            self.value = value.map { $0.value }
        } else if let value = try? container.decode([String: AnyCodable].self) {
            self.value = value.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable value cannot be decoded")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let value = self.value as? Bool {
            try container.encode(value)
        } else if let value = self.value as? Int {
            try container.encode(value)
        } else if let value = self.value as? Double {
            try container.encode(value)
        } else if let value = self.value as? String {
            try container.encode(value)
        } else if let value = self.value as? [AnyCodable] {
            try container.encode(value)
        } else if let value = self.value as? [String: AnyCodable] {
            try container.encode(value)
        } else {
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyCodable value cannot be encoded")
            throw EncodingError.invalidValue(value, context)
        }
    }
}
extension AnyCodable {
    func toJSONCompatible() -> Any {
        switch value {
        case let dict as [String: AnyCodable]:
            return dict.mapValues { $0.toJSONCompatible() }
        case let array as [AnyCodable]:
            return array.map { $0.toJSONCompatible() }
        case let value as [String: Any]:
            return value.mapValues { AnyCodable($0).toJSONCompatible() }
        case let value as [Any]:
            return value.map { AnyCodable($0).toJSONCompatible() }
        case is NSNull, is Bool, is Int, is Double, is String:
            return value
        default:
            return NSNull()
        }
    }
}
