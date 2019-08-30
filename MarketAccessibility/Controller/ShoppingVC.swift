//
//  ShoppingVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

protocol ShoppingVCDelegate: class {
    func updateLabel(withValue value: String)
}

class ShoppingVC: UIViewController, ShoppingVCDelegate {

    var drawInputView: DrawInputView!
    @IBOutlet weak var moneyValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDrawInput()
    }
    
    func setDrawInput() {
        
        drawInputView = DrawInputView(frame: .zero)
        drawInputView.shoppingVCDelegate = self
        drawInputView.backgroundColor = UIColor.App.background
        
        self.view.addSubview(drawInputView)
        
        drawInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            drawInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            drawInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            drawInputView.heightAnchor.constraint(equalToConstant: 250),
            drawInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
            ])
        moneyValueLabel.text = "\(0)"
    }
    
    func updateLabel(withValue value: String) {
        self.moneyValueLabel.text = value
    }

}
