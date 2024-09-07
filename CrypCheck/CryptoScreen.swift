//
//  CryptoScreen.swift
//  CrypCheck
//
//  Created by Vaibhav on 03/09/24.
//

import UIKit

class CryptoScreen: UIViewController {
    
    private let cryptoListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    private var viewModels = [CryptoTableViewCellViewModel]()
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.allowsFloats = true
        formatter.formatterBehavior = .default
        formatter.numberStyle = NumberFormatter.Style.currency
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Crypto Prices"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(cryptoListTableView)
        cryptoListTableView.dataSource = self
        cryptoListTableView.delegate = self
        
        NetworkManager.shared.fetchCryptoData { result in
            switch result {
            case .success(let models):
                self.viewModels = models.compactMap({ model in
                    let price = model.price_usd ?? 0
                    let formatter = CryptoScreen.numberFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    
                    let iconUrl = URL(string: NetworkManager.shared.icons.filter({ icon in
                        icon.asset_id == model.asset_id
                    }).first?.url ?? "")
                    
                    return CryptoTableViewCellViewModel(name: model.name ?? "Not found", symbol: model.asset_id, price: priceString ?? "Not found", iconUrl: iconUrl)
                })
                DispatchQueue.main.async {
                    self.cryptoListTableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cryptoListTableView.frame = view.bounds
    }
}

extension CryptoScreen: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
