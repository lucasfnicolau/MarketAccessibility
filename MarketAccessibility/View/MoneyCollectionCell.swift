//
//  MoneyCollectionCell.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 27/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class MoneyCollectionCell: UICollectionViewCell {
    
    var moneyButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLayout() {
        moneyButton = UIButton(frame: .zero)
        contentView.addSubview(moneyButton)
        moneyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moneyButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moneyButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moneyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            moneyButton.topAnchor.constraint(equalTo: self.topAnchor)
            
            ])
        
        
    }
    
    func setImage(fromName name: String){
        self.moneyButton.setImage(UIImage(named: name), for: .normal)
    }
    
}
