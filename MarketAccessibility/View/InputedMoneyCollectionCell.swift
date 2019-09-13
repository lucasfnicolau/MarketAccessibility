//
//  InputedMoneyCollectionCell.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 27/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit

class InputedMoneyCollectionCell: UICollectionViewCell {

    var deleteButton: ImageButton!
    var moneyImageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setLayout() {
        deleteButton = ImageButton(frame: .zero)
        deleteButton.setImage(#imageLiteral(resourceName: "x"), for: .normal)
        deleteButton.isAccessibilityElement = false

        moneyImageView = UIImageView()
        moneyImageView.isAccessibilityElement = true
        contentView.addSubview(moneyImageView)
        contentView.addSubview(deleteButton)

        moneyImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),

            moneyImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            moneyImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            moneyImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            moneyImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)

            ])
    }

    func setImage(fromName name: String) {
        self.moneyImageView.image = UIImage(named: name)
        moneyImageView.accessibilityLabel = currencyStr(Float(name) ?? 0)
        moneyImageView.accessibilityTraits = .none
    }
}
