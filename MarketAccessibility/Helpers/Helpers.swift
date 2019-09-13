//
//  Helpers.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable identifier_name
// swiftlint:disable trailing_whitespace

import UIKit

func getNumberFrom(string: String) -> String {
    switch string {
    case Number.zero.rawValue:
        return "0"
    case Number.one.rawValue:
        return "1"
    case Number.two.rawValue:
        return "2"
    case Number.three.rawValue:
        return "3"
    case Number.four.rawValue:
        return "4"
    case Number.five.rawValue:
        return "5"
    case Number.six.rawValue:
        return "6"
    case Number.seven.rawValue:
        return "7"
    case Number.eight.rawValue:
        return "8"
    case Number.nine.rawValue:
        return "9"
    default:
        return "0"
    }
}

func getNumberFrom(string: String) -> String.SubSequence {
    switch string {
    case Number.zero.rawValue:
        return "0"
    case Number.one.rawValue:
        return "1"
    case Number.two.rawValue:
        return "2"
    case Number.three.rawValue:
        return "3"
    case Number.four.rawValue:
        return "4"
    case Number.five.rawValue:
        return "5"
    case Number.six.rawValue:
        return "6"
    case Number.seven.rawValue:
        return "7"
    case Number.eight.rawValue:
        return "8"
    case Number.nine.rawValue:
        return "9"
    default:
        return "\(string)"
    }
}

func round(array: [Float]) -> [Float] {
    var roundedArray = array
    for i in 0 ..< roundedArray.count {
        roundedArray[i] = roundedArray[i].roundTo(places: 2)
    }
    return roundedArray
}

func calculateValue(fromArray array: [Float]) -> Float {
    var total: Float = 0

    for item in array {
        total += item
    }

    return total
}

func findSubsetSum(_ arr: [Float], targetSum: Float) -> [Float] {
    let length = arr.count
    let iEnd: UInt64 = 1 << length
    var currentSum: Float = 0
    var oldGray: UInt64 = 0
    
    var minDiff = Float.infinity
    var finalArr = [Float]()
    var finalGray: UInt64 = 0
    
    if iEnd == 0 || iEnd > 524288 { return [] }
    
    for i in 1 ..< iEnd {
        let newGray = i ^ (i >> 1)
        let bitChanged: UInt64 = oldGray ^ newGray
        let bitNumber = 31 - clz(bitChanged)
        
        if newGray & bitChanged != 0 {
            // Bit turned to 1 = Add element.
            currentSum += arr[Int(bitNumber)]
        } else {
            // Bit turned to 0 = Subtract element.
            currentSum -= arr[Int(bitNumber)]
        }
        
        let diff = currentSum - targetSum
        if diff < minDiff && diff >= 0 {
            minDiff = diff
            finalArr = arr
            finalGray = newGray
        }
        oldGray = newGray
    }
    
    return setFinalArray(finalArr, finalGray)
}

func clz(_ x: UInt64) -> UInt64 {
    var lz: UInt64 = 32
    var newX = x
    while newX != 0 {
        newX >>= 1
        lz -= 1
    }
    return lz
}

func setFinalArray(_ arr: [Float], _ bits: UInt64) -> [Float] {
    var resultArray = [Float]()
    for i in 0 ..< arr.count where (bits & (1 << i)) != 0 {
        resultArray.append(arr[i])
    }
    return resultArray
}

func currencyStr(_ value: Float) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = false
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: Identifier.ptBr.rawValue)
    
    return currencyFormatter.string(from: value as NSNumber) ?? "R$ 0,00"
}

func currencyStr(_ array: [Float]) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = false
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: Identifier.ptBr.rawValue)
    
    let totalValue = calculateValue(fromArray: array)
    
    return currencyFormatter.string(from: totalValue as NSNumber) ?? "R$ 0,00"
}

func setCompensationView(for vc: UIViewController, under otherView: UIView) {
    let view = UIView(frame: .zero)
    view.backgroundColor = UIColor.App.background
    vc.view.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
        view.topAnchor.constraint(equalTo: otherView.bottomAnchor),
        view.heightAnchor.constraint(equalToConstant: 100)
    ])
}

func roundChange(_ value: Float) -> Float {
    var newValue = value
    let strValue = String(format: "%.2f", value)
    let last = String(strValue.last ?? "0")
    
    if last.isEqual("1") || last.isEqual("6") {
        newValue -= 0.01
    } else if last.isEqual("2") || last.isEqual("7") {
        newValue -= 0.02
    } else if last.isEqual("3") || last.isEqual("8") {
        newValue += 0.02
    } else if last.isEqual("4") || last.isEqual("9") {
        newValue += 0.01
    }
    
    return newValue
}

func isSE() -> Bool {
    return UIScreen.main.bounds.width == SESize.width && UIScreen.main.bounds.height == SESize.height
}

func addHelpButton(forVC vc: UIViewController, onTopOf view: UIView) -> LargerTouchAreaButton {
    let helpBtn = LargerTouchAreaButton(frame: .zero)
    helpBtn.setImage(#imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate), for: .normal)
    helpBtn.tintColor = UIColor.App.actionColor
    vc.view.addSubview(helpBtn)
    helpBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        helpBtn.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
        helpBtn.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -8),
        helpBtn.widthAnchor.constraint(equalToConstant: 30 / SESize.width * UIScreen.main.bounds.width),
        helpBtn.heightAnchor.constraint(equalToConstant: 30 / SESize.width * UIScreen.main.bounds.width)
    ])
    
    helpBtn.addTarget(vc, action: #selector(vc.playHelpAudio), for: .touchUpInside)
    
    return helpBtn
}

func addHelpButton(forVC vc: UIViewController, under view: UIView) -> LargerTouchAreaButton {
    let helpBtn = LargerTouchAreaButton(frame: .zero)
    helpBtn.setImage(#imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate), for: .normal)
    helpBtn.tintColor = UIColor.App.actionColor
    vc.view.addSubview(helpBtn)
    helpBtn.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        helpBtn.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -16),
        helpBtn.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 8),
        helpBtn.widthAnchor.constraint(equalToConstant: 30 / SESize.width * UIScreen.main.bounds.width),
        helpBtn.heightAnchor.constraint(equalToConstant: 30 / SESize.width * UIScreen.main.bounds.width)
    ])
    
    helpBtn.addTarget(vc, action: #selector(vc.playHelpAudio), for: .touchUpInside)
    
    return helpBtn
}
