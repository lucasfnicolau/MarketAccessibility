//
//  SegmentedStackButton.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit

class SegmentedStackButton: UIButton {

    var buttonName = ""
    weak var segmentedStackViewDelegate: SegmentedStackViewDelegate!

    init(withName name: String) {
        super.init(frame: .zero)

        self.buttonName = name

        if name.isEqual(SegmentedStackOption.cedules.rawValue) {
            self.accessibilityLabel = NSLocalizedString(LocalizedString.cedules.rawValue, comment: "")
        } else if name.isEqual(SegmentedStackOption.coins.rawValue) {
            self.accessibilityLabel = NSLocalizedString(LocalizedString.coins.rawValue, comment: "")
        }

        self.addTarget(self, action: #selector(onTouch), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func onTouch() {
        segmentedStackViewDelegate.itemHasBeenTouched(name: buttonName)
    }
}
