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
    var bestPayment = [Float]()
    var stackView: UIStackView!
    var hasReachedResult = false
    var minDiffs = [Float]()
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var moneyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "COMO PAGAR"
        
        setStackView()
        
        guard let totalValueFloat = Float(totalValue.replacingOccurrences(of: "R$ ", with: "")
            .replacingOccurrences(of: ",", with: ".")) else { return }
        self.totalValueFloat = Float(String(format: "%.2f", totalValueFloat)) ?? 0.0
        
        collectionViewHandler = HowToPayVCCollectionHandler()
        collectionViewHandler.parentVC = self

        moneyCollectionView.delegate = collectionViewHandler
        moneyCollectionView.dataSource = collectionViewHandler

        moneyCollectionView.register(HowToPayCollectionCell.self,
                                     forCellWithReuseIdentifier: Identifier.howToPayCollectionCell.rawValue)
        
        payment = findSubsetSum(inputedMoney, targetSum: totalValueFloat)
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
    
    @objc func confirmAndMoveOn() {
        let changeVC = ChangeVC()
        changeVC.inputedMoney = calculateValue(fromArray: payment)
        changeVC.totalValue = totalValueFloat
        navigationController?.pushViewController(changeVC, animated: true)
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
    
    func findSubsetSum(_ arr: [Float], targetSum: Float) -> [Float] {
        let length = arr.count
        let iEnd = 1 << length
        var currentSum: Float = 0
        var oldGray = 0
        
        var minDiff = Float.infinity
        var finalArr = [Float]()
        var finalGray = 0
        
        for i in 1 ..< iEnd {
            let newGray = i ^ (i >> 1)
            let bitChanged = oldGray ^ newGray
            let bitNumber  = 31 - clz(bitChanged)
            
            if newGray & bitChanged != 0 {
                // Bit turned to 1 = Add element.
                currentSum += arr[bitNumber]
            } else {
                // Bit turned to 0 = Subtract element.
                currentSum -= arr[bitNumber]
            }
            
            let diff = currentSum - totalValueFloat
            if diff < minDiff && diff >= 0 {
                minDiff = diff
                finalArr = arr
                finalGray = newGray
            }
            oldGray = newGray
        }
        
        return setFinalArray(finalArr, finalGray)
    }
    
    func clz(_ x: Int) -> Int {
        var lz = 32
        var newX = x
        while newX != 0 {
            newX >>= 1
            lz -= 1
        }
        return lz
    }
    
    func setFinalArray(_ arr: [Float], _ bits: Int) -> [Float] {
        var resultArray = [Float]()
        for i in 0 ..< arr.count where (bits & (1 << i)) != 0 {
            resultArray.append(arr[i])
        }
        return resultArray
    }
}
