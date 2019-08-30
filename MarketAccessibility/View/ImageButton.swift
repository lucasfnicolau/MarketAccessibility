//
//  ImageButton.swift
//  MarketAccessibility
//
//  Created by Cassia Aparecida Barbosa on 28/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit

class ImageButton: UIButton {

    var position: Int = 0
    weak var delegate: MoneyVCDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func didSelect() {
        delegate?.delete(onPosition: position)
    }

}
