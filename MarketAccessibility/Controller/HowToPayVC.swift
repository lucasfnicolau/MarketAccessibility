//
//  HowToPayVC.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 02/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name

import UIKit

class HowToPayVC: UIViewController {
    
    var collectionViewHandler: HowToPayVCCollectionHandler!
    var inputedMoneyStr = ""
    var totalValueFloat: Float = 0
    var totalValue = ""
    var inputedMoney = [Float]()
    var paymentMoney = [Float]()
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var moneyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let totalValueFloat = Float(totalValue.replacingOccurrences(of: "R$ ", with: "")
            .replacingOccurrences(of: ",", with: ".")) else { return }
        self.totalValueFloat = totalValueFloat
        
        collectionViewHandler = HowToPayVCCollectionHandler()
        collectionViewHandler.parentVC = self

        moneyCollectionView.delegate = collectionViewHandler
        moneyCollectionView.dataSource = collectionViewHandler

        moneyCollectionView.register(HowToPayCollectionCell.self,
                                     forCellWithReuseIdentifier: Identifier.howToPayCollectionCell.rawValue)
        
        let payment = calculatePayment(fromValues: inputedMoney, atIndex: 0)
        moneyValueLabel.text = "R$ \(calculateValue(fromArray: payment))".replacingOccurrences(of: ".", with: ",")
        
        collectionViewHandler.inputedMoney = payment
        moneyCollectionView.reloadData()
    }
    
    func calculatePayment(fromValues values: [Float], atIndex index: Int) -> [Float] {
        
        var minDiff = Float.infinity
        var bestPayment = [Float]()
        
        for i in 0 ..< inputedMoney.count {
            var payment = [Float]()
            
            payment.append(inputedMoney[i])
            var sum = inputedMoney[i]
            let index = (i <= inputedMoney.count - 1 ? i + 1 : i)
            for j in index ..< inputedMoney.count {
                if inputedMoney[i] < totalValueFloat {
                    sum += inputedMoney[j]
                    payment.append(inputedMoney[j])
                }
                
                if sum >= totalValueFloat {
                    if calculateValue(fromArray: payment) - totalValueFloat < minDiff {
                        minDiff = calculateValue(fromArray: payment) - totalValueFloat
                        bestPayment = payment
                        
                        sum = inputedMoney[i]
                        payment = [inputedMoney[i]]
                    }
                }
            }
            
            if index == inputedMoney.count {
                if sum >= totalValueFloat {
                    if calculateValue(fromArray: payment) - totalValueFloat < minDiff {
                        minDiff = calculateValue(fromArray: payment) - totalValueFloat
                        bestPayment = payment
                        
                        sum = inputedMoney[i]
                        payment = [inputedMoney[i]]
                    }
                }
            }
        }
        
        return bestPayment
    }
    
    @objc func confirmAndMoveOn() {
        guard let text = moneyValueLabel.text else { return }
        if text.contains("R$") {
            let changeVC = ChangeVC()
            changeVC.inputedMoneyStr = inputedMoneyStr
            changeVC.totalValueStr = text
            
            navigationController?.pushViewController(changeVC, animated: true)
        }
    }
    
    func calculateValue(fromArray array: [Float]) -> Float {
        var total: Float = 0
        
        for item in array {
            total += item
        }
        
        return total
    }
}
