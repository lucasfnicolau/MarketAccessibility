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
    var speakInputView: SpeakInputView!
    @IBOutlet weak var moneyValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDrawInput()
    }
    
    func setDrawInput() {
        
        speakInputView = SpeakInputView(frame: .zero)
        speakInputView.shoppingVCDelegate = self
        speakInputView.backgroundColor = UIColor.App.background
        
        self.view.addSubview(speakInputView)
        
        speakInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            speakInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            speakInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            speakInputView.heightAnchor.constraint(equalToConstant: 250),
            speakInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
            ])
        moneyValueLabel.text = "\(0)"
    }
    
    func updateLabel(withValue value: String) {
        self.moneyValueLabel.text = value
    }

}
