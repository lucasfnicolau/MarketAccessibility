//
//  ChangeVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 31/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class ChangeVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBOutlet weak var moneyValueLabel: UILabel!
    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var collectionViewHandler: ChangeVCCollectionHandler!
    var inputedMoney: Float = 0
    var totalValue: Float = 0
    var continueBtn: UIButton!
    var backBtn: UIButton!
    var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let change = inputedMoney - totalValue
        var changeStr = ""
        
        if change <= 0 {
            changeStr = "R$ 0,00"
        } else {
            changeStr = String(format: "R$ %.2f", change).replacingOccurrences(of: ".", with: ",")
        }
        navigationItem.title = "TROCO: \(changeStr)"
        
        collectionViewHandler = ChangeVCCollectionHandler()
        collectionViewHandler.parentVC = self
        
        setMoneyInput()
        setFlowStackView()
        setInputedMoneyCollectionView()
        
        inputedMoneyCollectionView.delegate = collectionViewHandler
        inputedMoneyCollectionView.dataSource = collectionViewHandler
        
        collectionViewHandler.calculateValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.change
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
    }
    
    @objc func confirmAndMoveOn() {
        let animationVC = AnimationVC()
        animationVC.step = 1
        navigationController?.pushViewController(animationVC, animated: true)
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setFlowStackView() {
        backBtn = UIButton(frame: .zero)
        backBtn.setImage(#imageLiteral(resourceName: "back_2"), for: .normal)
        backBtn.addTarget(self, action: #selector(stopAndMoveBack), for: .touchUpInside)
        
        continueBtn = UIButton(frame: .zero)
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
            
            stackView.bottomAnchor.constraint(equalTo: moneyInputView.topAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            stackView.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
    
    @objc func reset() {
        collectionViewHandler.inputedMoney = []
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
    }
    
    func setMoneyInput() {
        
        moneyInputView = MoneyInputView(frame: .zero, withSelectedColor: UIColor.App.change)
        moneyInputView.moneyVCDelegate = collectionViewHandler
        moneyInputView.backgroundColor = UIColor.App.background
        
        self.view.addSubview(moneyInputView)
        
        moneyInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            moneyInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            moneyInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            moneyInputView.heightAnchor.constraint(equalToConstant: 250),
            moneyInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
            ])
        moneyValueLabel.text = "R$ 0,00"
        
    }
    
    func setInputedMoneyCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        inputedMoneyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        inputedMoneyCollectionView.backgroundColor = .clear
        inputedMoneyCollectionView.register(InputedMoneyCollectionCell.self,
                                            forCellWithReuseIdentifier: Identifier.inputedMoneyCollectionCell.rawValue)
        inputedMoneyCollectionView.delaysContentTouches = false
        self.view.addSubview(inputedMoneyCollectionView)
        
        inputedMoneyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputedMoneyCollectionView.topAnchor.constraint(equalTo: moneyValueLabel.bottomAnchor, constant: 50),
            inputedMoneyCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            inputedMoneyCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            inputedMoneyCollectionView.bottomAnchor.constraint(equalTo: continueBtn.topAnchor, constant: -8)
            
            ])
    }

}
