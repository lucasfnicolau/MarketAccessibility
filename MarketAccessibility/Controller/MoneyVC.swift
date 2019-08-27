//
//  MoneyVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class MoneyVC: UIViewController {

    var moneyInputView: MoneyInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMoneyInput()
        
        
        
    }
    
    
    func setMoneyInput(){
        
        moneyInputView = MoneyInputView(frame: .zero)
        
        moneyInputView.backgroundColor = UIColor.App.background
        
        self.view.addSubview(moneyInputView)
        
        moneyInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            moneyInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            moneyInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            moneyInputView.heightAnchor.constraint(equalToConstant: 0.4*UIScreen.main.bounds.height),
            moneyInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
            ])
    }

    
    
    

}
