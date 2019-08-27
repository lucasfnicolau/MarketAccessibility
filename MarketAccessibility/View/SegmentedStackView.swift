//
//  SegmentedStackView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

protocol SegmentedStackViewDelegate {
    func itemHasBeenTouched(name: String)
}

class SegmentedStackView: UIStackView, SegmentedStackViewDelegate {
    
    init(withViews views: [UIView]) {
        super.init(frame: .zero)
        
        for view in views {
            self.addArrangedSubview(view)
        }
        
        self.spacing = 8
        self.axis = .horizontal
        self.alignment = .fill
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
            arrangedSubviews[0].tintColor = UIColor.App.segmentedSelected
            arrangedSubviews[1].tintColor = UIColor.App.segmentedUnselected
        default:
            arrangedSubviews[0].tintColor = UIColor.App.segmentedUnselected
            arrangedSubviews[1].tintColor = UIColor.App.segmentedSelected
        }
    }
}
