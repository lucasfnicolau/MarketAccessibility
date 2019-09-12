//
//  InputMoneyViewCollectionHandler.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 28/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// s wiftlint:disable trailing_whitespace

import UIKit

class MoneyInputViewCollectionHandler: NSObject, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MoneyInputViewDelegate {

    var parentVC: MoneyInputView?
    var cedules: [Float] = [2.0, 5.0, 10.0, 20.0, 50.0, 100.0]
    var coins: [Float] = [0.05, 0.10, 0.25, 0.50, 1.0]
    var selectedData = [Float]()

    override init() {
        selectedData = cedules
    }

    func segmentedButtonChanged(to name: String) {

        switch name {
        case SegmentedStackOption.cedules.rawValue:
            selectedData = cedules
        default:
            selectedData = coins
        }
        parentVC?.moneyCollectionView.reloadData()
    }

    func delete(onPosition position: Int) {
        parentVC?.moneyVCDelegate.delete(onPosition: position)
    }

    func didSelect(value: Float) {
        parentVC?.moneyVCDelegate.moneySelected(value: value)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedData.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let moneyCollectionCell  = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.moneyCollectionCell.rawValue,
            for: indexPath) as? MoneyCollectionCell {
            moneyCollectionCell.setImage(fromName: String(selectedData[indexPath.row]))
            moneyCollectionCell.moneyButton.value = selectedData[indexPath.row]
            moneyCollectionCell.moneyButton.delegate = self
            return moneyCollectionCell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        var size = CGSize(width: 0, height: 0)

        if selectedData == cedules {
            size = CGSize(width: UIScreen.main.bounds.width / 3 - 10.0, height: 55)
        } else {
            size = CGSize(width: UIScreen.main.bounds.width / 5 - 10.0,
                          height: UIScreen.main.bounds.width / 5 - 10.0)
        }
        return size
    }
}
