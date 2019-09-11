//
//  MoneyVCCollectionHandler.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 28/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit

class MoneyVCCollectionHandler: NSObject, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MoneyVCDelegate {

    var inputedMoney = [Float]()
    var parentVC: MoneyVC?
    var defaults: UserDefaults!

    func delete(onPosition position: Int) {
        inputedMoney.remove(at: position)
        parentVC?.inputedMoneyCollectionView.reloadData()
        calculateValue()
    }

    func calculateValue() {
        parentVC?.moneyValueLabel.text = currencyStr(inputedMoney)

        defaults.set(parentVC?.moneyValueLabel.text, forKey: Key.moneyVCText.rawValue)
        defaults.set(inputedMoney, forKey: Key.moneyVCInputedMoney.rawValue)
    }

    func moneySelected(value: Float) {
        inputedMoney.append(value)
        inputedMoney = round(array: inputedMoney).sorted().reversed()
        parentVC?.inputedMoneyCollectionView.reloadData()
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
        let imageSize = CGSize(width: 324, height: 156)
        let width: CGFloat = isSE() ? 3.5 : 2.9
        let height: CGFloat = isSE() ? 3.2 : 2.7

        if inputedMoney[indexPath.row] > 1.0 {
            size = CGSize(width: imageSize.width / width, height: imageSize.height / height)
        } else {
            size = CGSize(width: UIScreen.main.bounds.width / 5 - 10.0,
                          height: UIScreen.main.bounds.width / 5 - 10.0)
        }
        return size
    }
}
