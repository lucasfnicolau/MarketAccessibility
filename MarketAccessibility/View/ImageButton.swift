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

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let verticalInset = CGFloat(15)
        let horizontalInset = CGFloat(15)

        let largerArea = CGRect(
            x: self.bounds.origin.x - horizontalInset,
            y: self.bounds.origin.y - verticalInset,
            width: self.bounds.size.width + horizontalInset * 2,
            height: self.bounds.size.height + verticalInset * 2
        )

        return largerArea.contains(point)
    }
}
