//
//  SegmentedStackView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit
    
protocol SegmentedStackViewDelegate: class {
    func itemHasBeenTouched(name: String)
}

class SegmentedStackView: UIStackView, SegmentedStackViewDelegate {
    var selectedColor = UIColor.App.white
    var unselectedColor = UIColor.App.money
    weak var moneyInputViewDelegate: MoneyInputViewDelegate?

    init(withViews views: [UIView]) {
        super.init(frame: .zero)

        for view in views {
            self.addArrangedSubview(view)
        }

        self.spacing = 10
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fillEqually
        
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    func itemHasBeenTouched(name: String) {
        switch name {
        case SegmentedStackOption.cedules.rawValue:
            guard let ceduleButton = arrangedSubviews[0] as? SegmentedStackButton else { return }
            ceduleButton.setImage(#imageLiteral(resourceName: "CeduleOption_Filled").withRenderingMode(.alwaysTemplate), for: .normal)
            ceduleButton.tintColor = selectedColor

            guard let coinButton = arrangedSubviews[1] as? SegmentedStackButton else { return }
            coinButton.setImage(#imageLiteral(resourceName: "CoinOption").withRenderingMode(.alwaysTemplate), for: .normal)
            coinButton.tintColor = unselectedColor
            moneyInputViewDelegate?.segmentedButtonChanged(to: name)
        default:
            guard let ceduleButton = arrangedSubviews[0] as? SegmentedStackButton else { return }
            ceduleButton.setImage(#imageLiteral(resourceName: "CeduleOption").withRenderingMode(.alwaysTemplate), for: .normal)
            ceduleButton.tintColor = unselectedColor

            guard let coinButton = arrangedSubviews[1] as? SegmentedStackButton else { return }
            coinButton.setImage(#imageLiteral(resourceName: "CoinOption_Filled").withRenderingMode(.alwaysTemplate), for: .normal)
            coinButton.tintColor = selectedColor
            moneyInputViewDelegate?.segmentedButtonChanged(to: name)
        }
    }
}
