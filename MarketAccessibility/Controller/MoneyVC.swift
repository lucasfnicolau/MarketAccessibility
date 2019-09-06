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
        return .default
    }
    
    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var collectionViewHandler: MoneyVCCollectionHandler!
    var continueBtn: UIButton!
    var defaults: UserDefaults!
    var isSE = false
    @IBOutlet weak var moneyValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.width == 320.0 && UIScreen.main.bounds.height == 568.0 {
            isSE = true
        }

        defaults = UserDefaults()
        navigationItem.setLeftBarButton(UIBarButtonItem(
            barButtonSystemItem: .trash, target: self, action: #selector(reset)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "continue"), style: .done,
                                                         target: self, action: #selector(confirmAndMoveOn)), animated: true)
        
        collectionViewHandler = MoneyVCCollectionHandler()
        collectionViewHandler.parentVC = self
        collectionViewHandler.defaults = defaults

        setMoneyInput()
        setContinueBtn()
        setInputedMoneyCollectionView()
        
        inputedMoneyCollectionView.delegate = collectionViewHandler
        inputedMoneyCollectionView.dataSource = collectionViewHandler
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moneyValueLabel.text = defaults.string(forKey: Key.moneyVCText.rawValue) ?? "R$ 0,00"
        guard let floatArray = defaults.array(forKey: Key.moneyVCInputedMoney.rawValue) as? [Float] else { return }
        collectionViewHandler.inputedMoney = floatArray
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.money
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = UIColor.App.money

    }
    
    @objc func confirmAndMoveOn() {
//        guard let text = moneyValueLabel.text else { return }
        
        if !collectionViewHandler.inputedMoney.isEmpty {
            let animationVC = AnimationVC()
//            animationVC.inputedMoneyStr = text
//            animationVC.inputedMoney = collectionViewHandler.inputedMoney
            navigationController?.pushViewController(animationVC, animated: true)
        }
    }
    
    @objc func reset() {
        collectionViewHandler.inputedMoney = []
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
    }

    func setMoneyInput() {

        moneyInputView = MoneyInputView(frame: .zero, withSelectedColor: UIColor.App.money)
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
            inputedMoneyCollectionView.topAnchor.constraint(equalTo: moneyValueLabel.bottomAnchor, constant: 25),
            inputedMoneyCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            inputedMoneyCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            inputedMoneyCollectionView.bottomAnchor.constraint(equalTo: continueBtn.topAnchor, constant: -8)

            ])
    }
    
    func setContinueBtn() {
        continueBtn = UIButton(frame: .zero)
        continueBtn.setImage(#imageLiteral(resourceName: "continue_1"), for: .normal)
        continueBtn.addTarget(self, action: #selector(confirmAndMoveOn), for: .touchUpInside)
        
        self.view.addSubview(continueBtn)
        
        guard let imageSize = continueBtn.imageView?.image?.size else { return }
        
        continueBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueBtn.bottomAnchor.constraint(equalTo: moneyInputView.topAnchor, constant: -8),
            continueBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            continueBtn.heightAnchor.constraint(equalToConstant: imageSize.height / 5),
            continueBtn.widthAnchor.constraint(equalToConstant: imageSize.width / 5)
        ])
    }

    @IBAction func unwindToMoneyVC(segue: UIStoryboardSegue) { }
}
