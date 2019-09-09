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
        return .lightContent
    }
    
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var changeImageView: UIImageView!
    var change: Float = 0
    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var collectionViewHandler: ChangeVCCollectionHandler!
    var inputedMoney: Float = 0
    var totalValue: Float = 0
    var continueBtn: UIButton!
    var backBtn: UIButton!
    var stackView: UIStackView!
    var isSE = false
    var change2: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.width == 320.0 && UIScreen.main.bounds.height == 568.0 {
            isSE = true
        }
        
        navigationItem.setLeftBarButtonItems([
            UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(stopAndMoveBack))
            ], animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "continue"),
                                                         style: .done, target: self,
                                                         action: #selector(confirmAndMoveOn)), animated: true)
        
        guard let btnImage = trashButton.imageView?.image else { return }
        trashButton.setImage(btnImage.withRenderingMode(.alwaysTemplate), for: .normal)

        change = inputedMoney - totalValue
        var changeStr = ""
        changeStr = String(format: "R$ %.2f", change).replacingOccurrences(of: ".", with: ",")
        var validate = changeStr.last

        if change <= 0 {
            changeStr = "R$ 0,00"
        }
        
        if validate == "1" {
            change2 = change - 0.01
            changeStr = String(format: "R$ %.2f", change2).replacingOccurrences(of: ".", with: ",")
        }
        

        navigationItem.title = "TROCO: \(changeStr)"
        
        collectionViewHandler = ChangeVCCollectionHandler()
        collectionViewHandler.parentVC = self
        
        setMoneyInput()
        setChangeImageView()
        setInputedMoneyCollectionView()
        
        inputedMoneyCollectionView.delegate = collectionViewHandler
        inputedMoneyCollectionView.dataSource = collectionViewHandler
        
        collectionViewHandler.calculateValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.white
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = UIColor.App.white
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor.App.change
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.App.change
        
        trashButton.tintColor = UIColor.App.actionColor
    }
    
    @objc func confirmAndMoveOn() {
        if String(format: "%.2f", calculateValue(fromArray: collectionViewHandler.inputedMoney))
            .isEqual(String(format: "%.2f", change)) {
            let animationVC = AnimationVC()
            animationVC.step = 1
            navigationController?.pushViewController(animationVC, animated: true)
        } else {
            let animationVC = AnimationVC()
            animationVC.step = 2
            navigationController?.pushViewController(animationVC, animated: true)
        }
        
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reset() {
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
            moneyInputView.heightAnchor.constraint(equalToConstant: (isSE ? 205 : 230)),
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
            inputedMoneyCollectionView.bottomAnchor.constraint(equalTo: self.changeImageView.topAnchor,
                                                               constant: -8)
            
            ])
    }

    func setChangeImageView() {
        changeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            changeImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            changeImageView.bottomAnchor.constraint(equalTo: self.moneyInputView.topAnchor,
                                                               constant: -8),
            changeImageView.heightAnchor.constraint(equalToConstant: 70),
            changeImageView.widthAnchor.constraint(equalToConstant: 107)
        ])
    }
}
