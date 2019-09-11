//
//  LargerTouchAreaButton.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 11/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class LargerTouchAreaButton: UIButton {
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
