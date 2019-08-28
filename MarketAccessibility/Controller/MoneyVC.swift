//
//  MoneyVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

protocol MoneyVCDelegate {
    func moneySelected(value: Int)
}

class MoneyVC: UIViewController {

    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var inputedMoney = [Int]()
    
    @IBOutlet weak var moneyValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMoneyInput()
        setInputedMoneyCollectionView()
    }
    
    
    func setMoneyInput(){
        
        moneyInputView = MoneyInputView(frame: .zero)
        
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
    
    func setInputedMoneyCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        inputedMoneyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        inputedMoneyCollectionView.backgroundColor = .clear
        inputedMoneyCollectionView.register(MoneyCollectionCell.self, forCellWithReuseIdentifier: Identifier.inputedMoneyCollectionCell.rawValue)
        inputedMoneyCollectionView.delaysContentTouches = false
    }

    
    
    

}

extension MoneyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MoneyVCDelegate {
    func moneySelected(value: Int) {
        // inputedMoney
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inputedMoney.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let inputedMoneyCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.inputedMoneyCollectionCell.rawValue, for: indexPath) as? InputedMoneyCollectionCell {
            
            inputedMoneyCell.setImage(fromName: String(inputedMoney[indexPath.row]))
            return inputedMoneyCell
            
        }
        return UICollectionViewCell()
    }
    

}
