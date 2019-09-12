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
        static var money: UIColor { return #colorLiteral(red: 0.1450980392, green: 0.1568627451, blue: 0.2117647059, alpha: 1) }
        static var shopping: UIColor { return #colorLiteral(red: 0.2549019608, green: 0.2784313725, blue: 0.4392156863, alpha: 1) }
        static var change: UIColor { return #colorLiteral(red: 0.2901960784, green: 0.3058823529, blue: 0.4117647059, alpha: 1) }
        static var check: UIColor { return #colorLiteral(red: 0.2509803922, green: 0.5490196078, blue: 0.6, alpha: 1) }
        static var error: UIColor { return #colorLiteral(red: 0.6117647059, green: 0.1098039216, blue: 0.06274509804, alpha: 1) }
        static var background: UIColor { return #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) }
        static var segmentedSelected: UIColor { return #colorLiteral(red: 0.8666666667, green: 0.431372549, blue: 0.2588235294, alpha: 1) }
        static var actionColor: UIColor { return #colorLiteral(red: 0.8666666667, green: 0.431372549, blue: 0.2588235294, alpha: 1) }
        static var black: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
        static var white: UIColor { return #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) }
    }
}

extension Float {
    func roundTo(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }

    func currencyStr() -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current

        return currencyFormatter.string(from: self as NSNumber)?
            .replacingOccurrences(of: "$", with: "$ ") ?? "R$ 0,00"
    }

    init?(currency: String) {
        self.init(currency.replacingOccurrences(of: "R$ ", with: "").replacingOccurrences(of: "$ ", with: "")
            .replacingOccurrences(of: ",", with: "."))
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

extension UIStackView {
    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subview.layer.cornerRadius = 20
        subview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let bottomView = UIView(frame: CGRect(x: 0, y: 57, width: UIScreen.main.bounds.width, height: 3))
        bottomView.backgroundColor = UIColor.App.shopping
        subview.addSubview(bottomView)

        insertSubview(subview, at: 0)
    }
}

extension UIViewController {
    @objc func playHelpAudio(_ sender: UIButton) {}
}
