//
//  Protocols.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 12/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

protocol MoneyVCDelegate: class {
    func moneySelected(value: Float)
    func delete(onPosition position: Int)
}

protocol ShoppingVCDelegate: class {
    func updateLabel(withValue value: String)
    func startHearing()
    func stopHearing()
}
