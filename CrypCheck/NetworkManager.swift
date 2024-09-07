//
//  NetworkManager.swift
//  CrypCheck
//
//  Created by Vaibhav on 03/09/24.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private struct Constants {
        static let apiKey = "FF23C281-69CC-4E5F-92A1-3CD997FE7939"
        static let baseURl = "https://rest.coinapi.io/v1/assets/"
    }
    
    public var icons: [Icon] = []
    
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    
    public func fetchCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        
        guard !icons.isEmpty else {
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.baseURl + "?apikey=" + Constants.apiKey) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
//                completion(.success(cryptos))
                completion(.success(cryptos.sorted { first, second -> Bool in
                    return (first.price_usd ?? 0 > second.price_usd ?? 0) && (first.price_usd ?? 0 < 100000) && (second.price_usd ?? 0 < 100000)
                }))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func fetchCryptoIcon() {
        
        guard let url = URL(string: "https://rest.coinapi.io/v1/assets/icons/55/?apikey=FF23C281-69CC-4E5F-92A1-3CD997FE7939") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {  [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock {
                    self?.fetchCryptoData(completion: completion)
                }
            } catch {
                
            }
        }
        task.resume()
    }
}
