//
//  InputedMoneyCollectionCell.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 27/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class InputedMoneyCollectionCell: UICollectionViewCell {
    
    var deleteButton: UIButton!
    var moneyImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setLayout() {
        deleteButton = UIButton(frame: .zero)
        deleteButton.setImage(#imageLiteral(resourceName: "x"), for: .normal)
        
        contentView.addSubview(deleteButton)
        contentView.addSubview(moneyImageView)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            deleteButton.widthAnchor.constraint(equalToConstant: 50),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            
            moneyImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            moneyImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            moneyImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            moneyImageView.topAnchor.constraint(equalTo: self.topAnchor)
            
            ])
        
        
    }
    
    func setImage(fromName name: String){
        self.moneyImageView.image = UIImage(named: name)
    }
}
