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

    @IBOutlet weak var moneyValueLabel: UILabel!
    
    var genericInputView: UIView!
    var drawInputView: DrawInputView!
    var speakInputView: SpeakInputView!
    var optionsStackView: UIStackView!
    var drawInputButton: UIButton!
    var speakInputButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInputView()
        moneyValueLabel.text = "R$ 0,00"
        setSegmentedStackView()
        setSpeakInputView()
        setDrawInput()
    }
    
    func setInputView() {
        genericInputView = UIView(frame: .zero)
        self.view.addSubview(genericInputView)
        genericInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genericInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            genericInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            genericInputView.heightAnchor.constraint(equalToConstant: 250),
            genericInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setSegmentedStackView() {
        drawInputButton = UIButton(frame: .zero)
        drawInputButton.setImage(#imageLiteral(resourceName: "btn_draw_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        
        speakInputButton = UIButton(frame: .zero)
        speakInputButton.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
        
        optionsStackView = UIStackView(arrangedSubviews: [drawInputButton, speakInputButton])
        optionsStackView.alignment = .fill
        optionsStackView.axis = .horizontal
        optionsStackView.distribution = .equalSpacing
        
        self.view.addSubview(optionsStackView)
        
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawInputButton.widthAnchor.constraint(equalToConstant: 42),
            drawInputButton.heightAnchor.constraint(equalToConstant: 35),
            
            speakInputButton.widthAnchor.constraint(equalToConstant: 28),
            speakInputButton.heightAnchor.constraint(equalToConstant: 35),
            
            optionsStackView.bottomAnchor.constraint(equalTo: genericInputView.topAnchor, constant: -8),
            optionsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            optionsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            optionsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setSpeakInputView() {
        speakInputView = SpeakInputView(frame: .zero)
        speakInputView.shoppingVCDelegate = self
        speakInputView.backgroundColor = UIColor.App.background
        
        genericInputView.addSubview(speakInputView)
        
        speakInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            speakInputView.leftAnchor.constraint(equalTo: genericInputView.leftAnchor),
            speakInputView.rightAnchor.constraint(equalTo: genericInputView.rightAnchor),
            speakInputView.heightAnchor.constraint(equalToConstant: 250),
            speakInputView.bottomAnchor.constraint(equalTo: genericInputView.bottomAnchor)
            
            ])
    }
    
    func setDrawInput() {
        drawInputView = DrawInputView(frame: .zero)
        drawInputView.shoppingVCDelegate = self
        drawInputView.backgroundColor = UIColor.App.background
        
        genericInputView.addSubview(drawInputView)
        
        drawInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            drawInputView.leftAnchor.constraint(equalTo: genericInputView.leftAnchor),
            drawInputView.rightAnchor.constraint(equalTo: genericInputView.rightAnchor),
            drawInputView.heightAnchor.constraint(equalToConstant: 250),
            drawInputView.bottomAnchor.constraint(equalTo: genericInputView.bottomAnchor)
            
            ])
    }
    
    func updateLabel(withValue value: String) {
        self.moneyValueLabel.text = value
    }

}
