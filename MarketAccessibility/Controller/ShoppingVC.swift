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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBOutlet weak var moneyValueLabel: UILabel!
    
    var genericInputView: UIView!
    var drawInputView: DrawInputView!
    var speakInputView: SpeakInputView!
    var optionsStackView: UIStackView!
    var drawInputButton: UIButton!
    var speakInputButton: UIButton!
    var selectedInputView: UIView!
    var inputedMoneyStr = ""
    var inputedMoney = [Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "VALOR DA COMPRA"
    
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .trash, target: self,
                                              action: #selector(reset)), animated: true)
        
        setInputView()
        moneyValueLabel.text = "R$ 0,00"
        setStackView()
        setSpeakInputView()
        setDrawInput()
        setFlowStackView()
        selectedInputView = drawInputView
        speakInputView.transform = CGAffineTransform(translationX: 0, y: 1000)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.shopping
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = UIColor.App.shopping
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
    
    func setStackView() {
        drawInputButton = UIButton(frame: .zero)
        drawInputButton.setImage(#imageLiteral(resourceName: "btn_draw_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        drawInputButton.addTarget(self, action: #selector(inputOptionSelected(_:)), for: .touchUpInside)
        drawInputButton.tintColor = UIColor.App.shopping
        
        speakInputButton = UIButton(frame: .zero)
        speakInputButton.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
        speakInputButton.addTarget(self, action: #selector(inputOptionSelected(_:)), for: .touchUpInside)
        speakInputButton.tintColor = UIColor.App.segmentedUnselected
        
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
            optionsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            optionsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
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
    
    @objc func inputOptionSelected(_ sender: UIButton) {
        if sender == drawInputButton && selectedInputView != drawInputView {
            selectedInputView = drawInputView
            
            drawInputButton.setImage(#imageLiteral(resourceName: "btn_draw_filled").withRenderingMode(.alwaysTemplate), for: .normal)
            drawInputButton.tintColor = UIColor.App.shopping
            
            speakInputButton.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
            speakInputButton.tintColor = UIColor.App.segmentedUnselected
            
            changeInputView(viewToHide: speakInputView, viewToAppear: drawInputView)
        } else if sender == speakInputButton && selectedInputView != speakInputButton {
            selectedInputView = speakInputView
            
            drawInputButton.setImage(#imageLiteral(resourceName: "btn_draw_outline").withRenderingMode(.alwaysTemplate), for: .normal)
            drawInputButton.tintColor = UIColor.App.segmentedUnselected
            
            speakInputButton.setImage(#imageLiteral(resourceName: "btn_mic_filled").withRenderingMode(.alwaysTemplate), for: .normal)
            speakInputButton.tintColor = UIColor.App.shopping
            
            changeInputView(viewToHide: drawInputView, viewToAppear: speakInputView)
        }
    }
    
    @objc func reset() {
        moneyValueLabel.text = "R$ 0,00"
        drawInputView.cedulesArray = []
        drawInputView.coinsArray = []
    }
    
    func changeInputView(viewToHide: UIView, viewToAppear: UIView) {
        UIView.animate(withDuration: 0.25, animations: {
            viewToHide.transform = CGAffineTransform(translationX: 0, y: 1000)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.25, animations: {
                viewToAppear.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        })
    }

    @objc func confirmAndMoveOn() {
        guard let text = moneyValueLabel.text else { return }
        if !text.isEqual("R$ 0,00") && !text.isEqual("R$ ,") && !text.isEqual("$ ,") && !text.isEqual("$ 0,00") {
            let howToPayVC = HowToPayVC()
            howToPayVC.inputedMoneyStr = inputedMoneyStr
            howToPayVC.inputedMoney = round(array: inputedMoney)
            howToPayVC.totalValue = text
            navigationController?.pushViewController(howToPayVC, animated: true)
        }
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setFlowStackView() {
        let backBtn = UIButton(frame: .zero)
        backBtn.setImage(#imageLiteral(resourceName: "back_2"), for: .normal)
        backBtn.addTarget(self, action: #selector(stopAndMoveBack), for: .touchUpInside)
        
        let continueBtn = UIButton(frame: .zero)
        continueBtn.setImage(#imageLiteral(resourceName: "continue_2"), for: .normal)
        continueBtn.addTarget(self, action: #selector(confirmAndMoveOn), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [backBtn, continueBtn])
        
        self.view.addSubview(stackView)
        
        guard let imageSize = continueBtn.imageView?.image?.size else { return }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backBtn.widthAnchor.constraint(equalToConstant: imageSize.width / 5),
            backBtn.heightAnchor.constraint(equalToConstant: imageSize.height / 5),
            
            continueBtn.widthAnchor.constraint(equalToConstant: imageSize.width / 5),
            continueBtn.heightAnchor.constraint(equalToConstant: imageSize.height / 5),
            
            stackView.bottomAnchor.constraint(equalTo: optionsStackView.topAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            stackView.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
}
