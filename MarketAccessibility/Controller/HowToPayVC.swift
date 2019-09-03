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
        return .default
    }
    
    var collectionViewHandler: HowToPayVCCollectionHandler!
    var inputedMoneyStr = ""
    var totalValueFloat: Float = 0
    var totalValue = ""
    var inputedMoney = [Float]()
    var paymentMoney = [Float]()
    var payment = [Float]()
    var stackView: UIStackView!
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var moneyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "COMO PAGAR"
        
        setStackView()
        
        guard let totalValueFloat = Float(totalValue.replacingOccurrences(of: "R$ ", with: "")
            .replacingOccurrences(of: ",", with: ".")) else { return }
        print(String(format: "%.2f", totalValueFloat))
        self.totalValueFloat = Float(String(format: "%.2f", totalValueFloat)) ?? 0.0
        
        collectionViewHandler = HowToPayVCCollectionHandler()
        collectionViewHandler.parentVC = self

        moneyCollectionView.delegate = collectionViewHandler
        moneyCollectionView.dataSource = collectionViewHandler

        moneyCollectionView.register(HowToPayCollectionCell.self,
                                     forCellWithReuseIdentifier: Identifier.howToPayCollectionCell.rawValue)
        
        payment = calculatePayment(fromValues: inputedMoney, atIndex: 0)
        moneyValueLabel.text = String(format: "R$ %.2f", calculateValue(fromArray: payment))
            .replacingOccurrences(of: ".", with: ",")
        
        setCollectionViewConstraints()
        
        collectionViewHandler.inputedMoney = payment
        moneyCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.shopping
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
    }
    
    func setCollectionViewConstraints() {
        moneyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moneyCollectionView.topAnchor.constraint(equalTo: moneyValueLabel.bottomAnchor, constant: 50),
            moneyCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            moneyCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            moneyCollectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -8)
        ])
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
                        payment = [inputedMoney[i] ]
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
    
    @objc func confirmAndMoveOn() {
        let changeVC = ChangeVC()
        changeVC.inputedMoney = calculateValue(fromArray: payment)
        changeVC.totalValue = totalValueFloat
        navigationController?.pushViewController(changeVC, animated: true)
    }
    
    func calculateValue(fromArray array: [Float]) -> Float {
        var total: Float = 0
        
        for item in array {
            total += item
        }
        
        return total
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setStackView() {
        let backBtn = UIButton(frame: .zero)
        backBtn.setImage(#imageLiteral(resourceName: "back_2"), for: .normal)
        backBtn.addTarget(self, action: #selector(stopAndMoveBack), for: .touchUpInside)
        
        let continueBtn = UIButton(frame: .zero)
        continueBtn.setImage(#imageLiteral(resourceName: "continue_3"), for: .normal)
        continueBtn.addTarget(self, action: #selector(confirmAndMoveOn), for: .touchUpInside)
        
        stackView = UIStackView(arrangedSubviews: [backBtn, continueBtn])
        
        self.view.addSubview(stackView)
        
        guard let imageSize = continueBtn.imageView?.image?.size else { return }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: imageSize.width / 5),
            backBtn.heightAnchor.constraint(equalToConstant: imageSize.height / 5),
            
            continueBtn.widthAnchor.constraint(equalToConstant: imageSize.width / 5),
            continueBtn.heightAnchor.constraint(equalToConstant: imageSize.height / 5),
            
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            stackView.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
}
