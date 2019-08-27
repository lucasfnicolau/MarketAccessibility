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

    var segmentedStackView: SegmentedStackView!
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMoneyInput()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    // segmented
    func setMoneyInput(){
        let ceduleButton = SegmentedStackButton(withName: SegmentedStackOption.cedules.rawValue)
        
        ceduleButton.setImage(#imageLiteral(resourceName: "cart_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        ceduleButton.tintColor = UIColor.App.segmentedSelected
        
        let coinButton = SegmentedStackButton(withName: SegmentedStackOption.coins.rawValue)
        
        coinButton.setImage(#imageLiteral(resourceName: "dollar_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        coinButton.tintColor = UIColor.App.segmentedUnselected
        
        segmentedStackView = SegmentedStackView(withViews: [ceduleButton,coinButton])
        
        ceduleButton.segmentedStackViewDelegate = segmentedStackView
        coinButton.segmentedStackViewDelegate = segmentedStackView
        
        self.addSubview(segmentedStackView)
        
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            segmentedStackView.widthAnchor.constraint(equalToConstant: 50),
            segmentedStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
    }
    
}
