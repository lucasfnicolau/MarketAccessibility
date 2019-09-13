//
//  MicButton.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 06/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class MicButton: UIButton {
    
    weak var delegate: ShoppingVCDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.accessibilityLabel = NSLocalizedString(LocalizedString.recordButton.rawValue, comment: "")
        self.accessibilityValue = NSLocalizedString(LocalizedString.recordButtonAction.rawValue, comment: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setImage(#imageLiteral(resourceName: "btn_mic_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        delegate.startHearing()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
        delegate.stopHearing()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
        delegate.stopHearing()
    }
}
