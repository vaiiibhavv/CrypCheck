//
//  CryptoTableViewCellViewModel.swift
//  CrypCheck
//
//  Created by Vaibhav on 04/09/24.
//

import Foundation

class CryptoTableViewCellViewModel {
    
    let name: String
    let symbol: String
    let price: String
    let iconUrl: URL?
    var iconData: Data?
    
    init(name: String, symbol: String, price: String, iconUrl: URL?) {
        self.name = name
        self.symbol = symbol
        self.price = price
        self.iconUrl = iconUrl
    }
}
