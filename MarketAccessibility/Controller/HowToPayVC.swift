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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var collectionViewHandler: HowToPayVCCollectionHandler!
    var inputedMoneyStr = ""
    var totalValueFloat: Float = 0
    var totalValue = ""
    var inputedMoney = [Float]()
    var paymentMoney = [Float]()
    var payment = [Float]()
    var bestPayment = [Float]()
    var hasReachedResult = false
    var minDiffs = [Float]()
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var moneyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "COMO PAGAR"
        
        navigationItem.setLeftBarButtonItems([
            UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(stopAndMoveBack))
            ], animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "continue"),
                                                         style: .done, target: self,
                                                         action: #selector(confirmAndMoveOn)), animated: true)
        
        guard let totalValueFloat = Float(currency: totalValue) else { return }
        self.totalValueFloat = Float(String(format: "%.2f", totalValueFloat)) ?? 0.0
        
        collectionViewHandler = HowToPayVCCollectionHandler()
        collectionViewHandler.parentVC = self

        moneyCollectionView.delegate = collectionViewHandler
        moneyCollectionView.dataSource = collectionViewHandler

        moneyCollectionView.register(HowToPayCollectionCell.self,
                                     forCellWithReuseIdentifier: Identifier.howToPayCollectionCell.rawValue)
        
        let resultArray = findSubsetSum(inputedMoney, targetSum: totalValueFloat)
        payment = resultArray.isEmpty ? calculatePayment(fromValues: payment, atIndex: 0) : resultArray
        
        moneyValueLabel.text = String(format: "R$ %.2f", calculateValue(fromArray: payment))
            .replacingOccurrences(of: ".", with: ",")

        collectionViewHandler.inputedMoney = payment
        moneyCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.white
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = UIColor.App.white
        navigationController?.navigationBar.barTintColor = UIColor.App.shopping
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.App.shopping
    }
    
    @objc func confirmAndMoveOn() {
        if String(format: "%.2f", calculateValue(fromArray: payment)).isEqual(String(format: "%.2f", totalValueFloat)) {
            let animationVC = AnimationVC()
            animationVC.step = 1
            navigationController?.pushViewController(animationVC, animated: true)
        } else {
            let changeVC = ChangeVC()
            changeVC.inputedMoney = calculateValue(fromArray: payment)
            changeVC.totalValue = totalValueFloat
            navigationController?.pushViewController(changeVC, animated: true)
        }
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func calculatePayment(fromValues values: [Float], atIndex index: Int) -> [Float] {
        
        var minDiff = Float.infinity
        var bestPayment = [Float]()
        
        for i in 0 ..< inputedMoney.count {
            var payment = [Float]()
            
            payment.append(inputedMoney[i] )
            var sum = inputedMoney[i].roundTo(places: 2)
            let index = (i <= inputedMoney.count - 1 ? i + 1 : i)
            for j in index ..< inputedMoney.count {
                if inputedMoney[i] < totalValueFloat {
                    sum += inputedMoney[j]
                    payment.append(inputedMoney[j])
                }
                
                if sum > totalValueFloat ||
                    String(format: "%.2f", sum).isEqual(String(format: "%.2f", totalValueFloat)) {
                    if calculateValue(fromArray: payment)  - totalValueFloat < minDiff {
                        minDiff = calculateValue(fromArray: payment)  - totalValueFloat
                        bestPayment = payment
                        
                        sum = inputedMoney[i]
                        payment = [inputedMoney[i]]
                    }
                }
            }
            
            if index == inputedMoney.count {
                if sum > totalValueFloat ||
                    String(format: "%.2f", sum).isEqual(String(format: "%.2f", totalValueFloat)) {
                    if calculateValue(fromArray: payment)  - totalValueFloat < minDiff {
                        minDiff = calculateValue(fromArray: payment)  - totalValueFloat
                        bestPayment = payment
                        
                        sum = inputedMoney[i]
                        payment = [inputedMoney[i]]
                    }
                }
            }
        }
        
        return bestPayment
    }
}
