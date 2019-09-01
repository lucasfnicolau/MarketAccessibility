//
//  Enums.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
    
import Foundation

enum SegmentedStackOption: String {
    case cedules
    case coins
}

enum Identifier: String {
    case moneyCollectionCell
    case inputedMoneyCollectionCell
    case ptBr = "pt-BR"
}

enum Entity: String {
    case jsonTemplate = "JSONTemplate"
}

enum Number: String {
    case zero = "ZERO"
    case one = "UM"
    case two = "DOIS"
    case three = "TRÊS"
    case four = "QUATRO"
    case five = "CINCO"
    case six = "SEIS"
    case seven = "SETE"
    case eight = "OITO"
    case nine = "NOVE"
}

enum Image: String {
    case microphoneOn = "btn_mic_outline"
    case microphoneOff = "btn_mic_filled"
//    case
}

enum KeyPath: String {
    case strokeEnd
}

enum Key: String {
    case checkAnim
    case appHasBeenOpenedBefore
}
