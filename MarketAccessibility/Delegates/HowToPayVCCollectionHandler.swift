//
//  HowToPayVCCollectionHandler.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 02/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class HowToPayVCCollectionHandler: NSObject, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var inputedMoney = [Float]()
    var parentVC: HowToPayVC?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inputedMoney.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let moneyCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.howToPayCollectionCell.rawValue,
            for: indexPath) as? HowToPayCollectionCell {
            
            moneyCell.setImage(fromName: String(inputedMoney[indexPath.row]))
            return moneyCell
            
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
