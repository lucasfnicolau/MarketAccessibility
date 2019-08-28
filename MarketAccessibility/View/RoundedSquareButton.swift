//
//  RoundedSquareButton.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedSquareButton: UIButton {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setLayout()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }

    func setLayout() {
        self.layer.cornerRadius = 20
        self.backgroundColor = #colorLiteral(red: 0.2509803922, green: 0.5490196078, blue: 0.6, alpha: 1)
    }
}
