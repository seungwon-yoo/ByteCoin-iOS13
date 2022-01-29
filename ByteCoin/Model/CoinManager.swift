//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(_ coinManager: CoinManager, error: Error)
    func didUpdateCoinPrice(_ coinManager: CoinManager, coinPrice: String, currency: String)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B2910D24-D208-41D7-927F-3DDB81E80022"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let finalURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: finalURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let price = parseJSON(safeData) {
                        DispatchQueue.main.async {
                            delegate?.didUpdateCoinPrice(self, coinPrice: price, currency: currency)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = String(format: "%.2f", decodedData.rate)
            
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
}
