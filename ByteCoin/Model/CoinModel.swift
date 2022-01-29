//
//  CoinModel.swift
//  ByteCoin
//
//  Created by 유승원 on 2022/01/30.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let coinPrice: Double
    let currency: String
    
    var priceString: String {
        return String(format: "%.2f", coinPrice)
    }
}
