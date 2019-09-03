//
//  Extensions.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 27/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit

extension UIColor {
    struct App {
        static var money: UIColor { return #colorLiteral(red: 0.2509803922, green: 0.5490196078, blue: 0.6, alpha: 1) }
        static var shopping: UIColor { return #colorLiteral(red: 0.6117647059, green: 0.1098039216, blue: 0.06274509804, alpha: 1) }
        static var change: UIColor { return #colorLiteral(red: 0.9137254902, green: 0.431372549, blue: 0.1803921569, alpha: 1) }
        static var stop: UIColor { return #colorLiteral(red: 0.6, green: 0.5058823529, blue: 0.431372549, alpha: 1) }
        static var background: UIColor { return #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) }
        static var segmentedSelected: UIColor { return #colorLiteral(red: 0.2509803922, green: 0.5490196078, blue: 0.6, alpha: 1) }
        static var segmentedUnselected: UIColor { return #colorLiteral(red: 0.6, green: 0.5058823529, blue: 0.431372549, alpha: 1) }
        static var black: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
        static var white: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    }
}

extension Float {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
    func count(occurrencesOf char: Character) -> Int {
        var count = 0
        Array(self).forEach { (element) in
            if element == char {
                count += 1
            }
        }
        return count
    }
}
