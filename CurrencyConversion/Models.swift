//
//  Models.swift
//  CurrencyConversion
//
//  Created by Srujan k on 01/12/20.
//

import Foundation

struct Constants {
    struct APIEndPoints {
        static let list = "list"
        static let live = "live"
    }
    static let DidReceiveLiveCurrency = "DidReceiveLiveCurrency"
    static let currency = "currency"
}

struct Country {
    let code: String?
    let value: String?
}
struct List: Codable{
    let success: Bool?
    let terms, privacy: String?
    let currencies: [String: String]?
    let error: CCError?
    let quotes: [String: Decimal]?
}
struct CCError: Codable {
    let code: Int?
    let type: String?
    let info: String?
}

struct Currency{
    let countryName: String?
    let code: String?
    let value: Decimal?
}
