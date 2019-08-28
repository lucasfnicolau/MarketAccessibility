//
//  MoneyVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

protocol MoneyVCDelegate: class {
    func moneySelected(value: Float)
    func delete(onPosition position: Int)
}

class MoneyVC: UIViewController {

    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var inputedMoney = [Float]()

    @IBOutlet weak var moneyValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setLeftBarButton(UIBarButtonItem(
            barButtonSystemItem: .trash, target: self, action: #selector(reset)), animated: true)
        navigationController?.navigationBar.tintColor = UIColor.App.money

        setMoneyInput()
        setInputedMoneyCollectionView()
        inputedMoneyCollectionView.delegate = self
        inputedMoneyCollectionView.dataSource = self
        calculateValue()
    }

    @objc func reset() {
        inputedMoney = []
        inputedMoneyCollectionView.reloadData()
        calculateValue()
    }

    func setMoneyInput() {

        moneyInputView = MoneyInputView(frame: .zero)
        moneyInputView.moneyVCDelegate = self
        moneyInputView.backgroundColor = UIColor.App.background

        self.view.addSubview(moneyInputView)

        moneyInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            moneyInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            moneyInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            moneyInputView.heightAnchor.constraint(equalToConstant: 250),
            moneyInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

            ])
        moneyValueLabel.text = "\(0)"

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
            inputedMoneyCollectionView.topAnchor.constraint(equalTo: moneyValueLabel.bottomAnchor, constant: 8),
            inputedMoneyCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            inputedMoneyCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            inputedMoneyCollectionView.bottomAnchor.constraint(equalTo: moneyInputView.topAnchor, constant: 8)

            ])
    }

}

extension MoneyVC: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, MoneyVCDelegate {

    func delete(onPosition position: Int) {
        inputedMoney.remove(at: position)
        inputedMoneyCollectionView.reloadData()
        calculateValue()
    }

    func calculateValue() {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        var totalValue: Float = 0
        for value in inputedMoney {
            totalValue += value
        }
        moneyValueLabel.text = currencyFormatter.string(from: NSNumber(value: totalValue))?
            .replacingOccurrences(of: "$", with: "$ ")
    }

    func moneySelected(value: Float) {
        inputedMoney.append(value)
        inputedMoneyCollectionView.reloadData()
        calculateValue()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inputedMoney.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let inputedMoneyCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.inputedMoneyCollectionCell.rawValue,
            for: indexPath) as? InputedMoneyCollectionCell {
            
            inputedMoneyCell.setImage(fromName: String(inputedMoney[indexPath.row]))
            inputedMoneyCell.deleteButton.delegate = self
            inputedMoneyCell.deleteButton.position = indexPath.row
            return inputedMoneyCell
            
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        
        if inputedMoney[indexPath.row] > 1.0 {
            size = CGSize(width: UIScreen.main.bounds.width / 3 - 10.0, height: 55)
        } else {
            size = CGSize(width: UIScreen.main.bounds.width / 5 - 10.0,
                          height: UIScreen.main.bounds.width / 5 - 10.0)
        }
        return size
    }

}
