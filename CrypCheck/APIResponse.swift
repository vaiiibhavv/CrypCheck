//
//  APIResponse.swift
//  CrypCheck
//
//  Created by Vaibhav on 03/09/24.
//

import Foundation

struct Crypto: Codable {
    let asset_id: String
    let name: String?
    let price_usd: Float?
    let id_icon: String?
}

struct Icon: Codable {
    let asset_id: String
    let url: String
}
