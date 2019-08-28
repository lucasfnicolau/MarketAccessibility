//
//  MoneyInputView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

@IBDesignable
class MoneyInputView: UIView {

    var segmentedStackView: SegmentedStackView!
    var moneyCollectionView: UICollectionView!
    var cedules = [2,5,10,20,50,100]
    var moneyVCDelegate: MoneyVCDelegate!
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setMoneyInput()
        moneyCollectionView.delegate = self
        moneyCollectionView.dataSource = self
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // segmented
    func setMoneyInput(){
        
        // MARK:- criaçao da collection
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        moneyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        moneyCollectionView.backgroundColor = .clear
        moneyCollectionView.register(MoneyCollectionCell.self, forCellWithReuseIdentifier: Identifier.moneyCollectionCell.rawValue)
        moneyCollectionView.delaysContentTouches = false
        
        // MARK:- criaçao da custom segmented
        
        let ceduleButton = SegmentedStackButton(withName: SegmentedStackOption.cedules.rawValue)
        
        ceduleButton.setImage(#imageLiteral(resourceName: "CeduleOption_Filled").withRenderingMode(.alwaysTemplate), for: .normal)
        ceduleButton.tintColor = UIColor.App.segmentedSelected
        
        let coinButton = SegmentedStackButton(withName: SegmentedStackOption.coins.rawValue)
        
        coinButton.setImage(#imageLiteral(resourceName: "CoinOption").withRenderingMode(.alwaysTemplate), for: .normal)
        coinButton.tintColor = UIColor.App.segmentedUnselected
        
        segmentedStackView = SegmentedStackView(withViews: [ceduleButton,coinButton])
        
        ceduleButton.segmentedStackViewDelegate = segmentedStackView
        coinButton.segmentedStackViewDelegate = segmentedStackView
        
        self.addSubview(moneyCollectionView)
        self.addSubview(segmentedStackView)
        
        moneyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            moneyCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            moneyCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            moneyCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            moneyCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -64),
            
            segmentedStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            segmentedStackView.heightAnchor.constraint(equalToConstant: 30),
            segmentedStackView.widthAnchor.constraint(equalToConstant: 150),
            
            ])
    }
    
}


extension MoneyInputView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cedules.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let moneyCollectionCell  = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.moneyCollectionCell.rawValue, for: indexPath) as? MoneyCollectionCell{
            moneyCollectionCell.setImage(fromName: String(cedules[indexPath.row]))
            return moneyCollectionCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: UIScreen.main.bounds.width/3 - 10.0, height: 55)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moneyVCDelegate.moneySelected(value: cedules[indexPath.row])
    }
    
}
