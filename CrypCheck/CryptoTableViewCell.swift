//
//  CryptoTableViewCell.swift
//  CrypCheck
//
//  Created by Vaibhav on 03/09/24.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {

    static let identifier = "CryptoTableViewCell"
    
    private let cryptoNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cryptoSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cryptoPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cryptoNameLabel)
        contentView.addSubview(cryptoSymbolLabel)
        contentView.addSubview(cryptoPriceLabel)
        contentView.addSubview(iconImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cryptoNameLabel.sizeToFit()
        cryptoPriceLabel.sizeToFit()
        cryptoSymbolLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height/1.1),
            iconImageView.widthAnchor.constraint(equalToConstant: contentView.frame.height/1.1),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            cryptoNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            cryptoNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            cryptoSymbolLabel.leadingAnchor.constraint(equalTo: cryptoNameLabel.leadingAnchor),
            cryptoSymbolLabel.topAnchor.constraint(equalTo: cryptoNameLabel.bottomAnchor, constant: 5),
            cryptoSymbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            cryptoPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cryptoPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        cryptoNameLabel.text = nil
        cryptoPriceLabel.text = nil
        cryptoSymbolLabel.text = nil
    }
    
    func configure(with viewModel: CryptoTableViewCellViewModel) {
        cryptoNameLabel.text = viewModel.name
        cryptoPriceLabel.text = viewModel.price
        cryptoSymbolLabel.text = viewModel.symbol
        
        if let data = viewModel.iconData {
            iconImageView.image = UIImage(data: data)
        } else if let url = viewModel.iconUrl {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data {
                    viewModel.iconData = data
                    DispatchQueue.main.async {
                        self?.iconImageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
    
}
