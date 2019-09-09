//
//  MoneyVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

protocol MoneyVCDelegate: class {
    func moneySelected(value: Float)
    func delete(onPosition position: Int)
}

class MoneyVC: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var collectionViewHandler: MoneyVCCollectionHandler!
    var defaults: UserDefaults!
    var isSE = false
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.width == 320.0 && UIScreen.main.bounds.height == 568.0 {
            isSE = true
        }

        defaults = UserDefaults()
        navigationItem.setRightBarButton(
            UIBarButtonItem(image: #imageLiteral(resourceName: "continue"), style: .done, target: self,
                            action: #selector(confirmAndMoveOn)), animated: true)
        
        guard let btnImage = trashButton.imageView?.image else { return }
        trashButton.setImage(btnImage.withRenderingMode(.alwaysTemplate), for: .normal)
        
        collectionViewHandler = MoneyVCCollectionHandler()
        collectionViewHandler.parentVC = self
        collectionViewHandler.defaults = defaults

        setMoneyInput()
        setInputedMoneyCollectionView()
        
        inputedMoneyCollectionView.delegate = collectionViewHandler
        inputedMoneyCollectionView.dataSource = collectionViewHandler
        
        self.view.backgroundColor = UIColor.App.money
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moneyValueLabel.text = defaults.string(forKey: Key.moneyVCText.rawValue) ?? currencyStr(0)
        guard let floatArray = defaults.array(forKey: Key.moneyVCInputedMoney.rawValue) as? [Float] else { return }
        collectionViewHandler.inputedMoney = floatArray
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.white
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = UIColor.App.actionColor
        navigationController?.navigationBar.barTintColor = UIColor.App.money
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.App.money
        
        trashButton.tintColor = UIColor.App.actionColor
    }
    
    @objc func confirmAndMoveOn() {
        if !collectionViewHandler.inputedMoney.isEmpty {
            let animationVC = AnimationVC()
            navigationController?.pushViewController(animationVC, animated: true)
        }
    }
    
    @IBAction func reset() {
        collectionViewHandler.inputedMoney = []
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
    }

    func setMoneyInput() {

        moneyInputView = MoneyInputView(frame: .zero, withSelectedColor: UIColor.App.actionColor)
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
        
        moneyValueLabel.text = currencyStr(0)
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
            inputedMoneyCollectionView.topAnchor.constraint(equalTo: moneyValueLabel.bottomAnchor, constant: 25),
            inputedMoneyCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            inputedMoneyCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            inputedMoneyCollectionView.bottomAnchor.constraint(equalTo: moneyInputView.topAnchor, constant: -8)

            ])
    }
}
