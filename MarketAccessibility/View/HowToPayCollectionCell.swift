//
//  HowToPayCollectionCell.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 02/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class HowToPayCollectionCell: UICollectionViewCell {
    
    var moneyImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLayout() {
        moneyImageView = UIImageView()
        contentView.addSubview(moneyImageView)
        moneyImageView.isAccessibilityElement = true
        
        moneyImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moneyImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moneyImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moneyImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            moneyImageView.topAnchor.constraint(equalTo: self.topAnchor)
            ])
    }
    
    func setImage(fromName name: String) {
        self.moneyImageView.image = UIImage(named: name)
        moneyImageView.accessibilityLabel = currencyStr(Float(name) ?? 0)
        moneyImageView.accessibilityTraits = .none
    }

}
