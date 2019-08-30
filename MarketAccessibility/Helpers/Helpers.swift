//
//  Helpers.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import Foundation

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
