//
//  MoneyButton.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit

@IBDesignable
class MoneyButton: UIButton {

    var value: Float = 0
    weak var delegate: MoneyInputViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func didSelect() {
        delegate?.didSelect(value: value)
    }
}
