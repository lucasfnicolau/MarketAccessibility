//
//  MoneyInputView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

@IBDesignable
class MoneyInputView: UIView {
    
    var ceduleButtons = [UIButton]()
    var coinButtons = [UIButton]()
    var segmentedStackView: SegmentedStackView!
    var cedulesOptionButton: SegmentedStackButton!
    var coinsOptionButton: SegmentedStackButton!

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 150, width: UIScreen.main.bounds.width, height: 150)
        
        cedulesOptionButton = SegmentedStackButton(withName: SegmentedStackOption.cedules.rawValue)
        cedulesOptionButton.setImage(#imageLiteral(resourceName: "dollar_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        
        coinsOptionButton = SegmentedStackButton(withName: SegmentedStackOption.coins.rawValue)
        coinsOptionButton.setImage(#imageLiteral(resourceName: "cart_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        
        segmentedStackView = SegmentedStackView(arrangedSubviews: [cedulesOptionButton, coinsOptionButton])
        segmentedStackView.frame = .zero
        segmentedStackView.arrangedSubviews[0].tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        segmentedStackView.arrangedSubviews[1].tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cedulesOptionButton.segmentedStackViewDelegate = segmentedStackView
        coinsOptionButton.segmentedStackViewDelegate = segmentedStackView
      
        self.addSubview(segmentedStackView)
        
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            segmentedStackView.widthAnchor.constraint(equalToConstant: 75),
            segmentedStackView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}
