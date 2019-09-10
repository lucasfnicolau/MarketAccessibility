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
    func startHearing()
    func stopHearing()
}

class ShoppingVC: UIViewController, ShoppingVCDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    var genericInputView: UIView!
    var drawInputView: DrawInputView!
    var speakInputView: SpeakInputView!
    var optionsStackView: UIStackView!
    var drawInputButton: UIButton!
    var speakInputButton: MicButton!
    var selectedInputView: UIView!
    var inputedMoneyStr = ""
    var inputedMoney = [Float]()
    var defaults: UserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "VALOR DA COMPRA"
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        navigationController?.navigationBar.topItem?.title = " "
        navigationItem.setRightBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "continue"),
                                                         style: .done, target: self,
                                                         action: #selector(confirmAndMoveOn)), animated: true)
        
        guard let btnImage = trashButton.imageView?.image else { return }
        trashButton.setImage(btnImage.withRenderingMode(.alwaysTemplate), for: .normal)
        
        defaults = UserDefaults()
        inputedMoneyStr = defaults.string(forKey: Key.moneyVCText.rawValue) ?? currencyStr(0)
        guard let floatArray = defaults.array(forKey: Key.moneyVCInputedMoney.rawValue) as? [Float] else { return }
        inputedMoney = floatArray
        
        setInputView()
        moneyValueLabel.text = currencyStr(0)
        setStackView()
        setSpeakInputView()
        setDrawInput()
        selectedInputView = drawInputView
        speakInputView.transform = CGAffineTransform(translationX: 0, y: 1000)
        
        setCompensationView(for: self, under: drawInputView)
        setCompensationView(for: self, under: speakInputView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let font = UIFont(name: "Avenir", size: 22) else { return }
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.white,
            NSAttributedString.Key.font: font
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = UIColor.App.actionColor
        navigationController?.navigationBar.barTintColor = UIColor.App.shopping
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.App.shopping
        
        trashButton.tintColor = UIColor.App.actionColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setInputView() {
        genericInputView = UIView(frame: .zero)
        self.view.addSubview(genericInputView)
        genericInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genericInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            genericInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            genericInputView.heightAnchor.constraint(equalToConstant: 250),
            genericInputView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    func setStackView() {
        drawInputButton = UIButton(frame: .zero)
        drawInputButton.setImage(#imageLiteral(resourceName: "btn_draw_filled").withRenderingMode(.alwaysTemplate), for: .normal)
        drawInputButton.addTarget(self, action: #selector(inputOptionSelected(_:)), for: .touchUpInside)
        drawInputButton.tintColor = UIColor.App.actionColor
        
        speakInputButton = MicButton(frame: .zero)
        speakInputButton.delegate = self
        speakInputButton.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
        speakInputButton.addTarget(self, action: #selector(inputOptionSelected(_:)), for: .touchUpInside)
        speakInputButton.tintColor = UIColor.App.shopping
        
        optionsStackView = UIStackView(arrangedSubviews: [drawInputButton, speakInputButton])
        optionsStackView.alignment = .center
        optionsStackView.axis = .horizontal
        optionsStackView.distribution = .equalCentering
        optionsStackView.addBackground(color: UIColor.App.background)
        
        self.view.addSubview(optionsStackView)
        
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            drawInputButton.widthAnchor.constraint(equalToConstant: 42),
            drawInputButton.heightAnchor.constraint(equalToConstant: 40),
            drawInputButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 55),
            
            speakInputButton.widthAnchor.constraint(equalToConstant: 28),
            speakInputButton.heightAnchor.constraint(equalToConstant: 40),
            speakInputButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -55),
            
            optionsStackView.bottomAnchor.constraint(equalTo: genericInputView.topAnchor, constant: 0),
            optionsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            optionsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            optionsStackView.heightAnchor.constraint(equalToConstant: 60)
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
            drawInputButton.tintColor = UIColor.App.actionColor
            
            speakInputButton.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
            speakInputButton.tintColor = UIColor.App.shopping
            
            changeInputView(viewToHide: speakInputView, viewToAppear: drawInputView)
        } else if sender == speakInputButton && selectedInputView != speakInputView {
            selectedInputView = speakInputView
            
            drawInputButton.setImage(#imageLiteral(resourceName: "btn_draw_outline").withRenderingMode(.alwaysTemplate), for: .normal)
            drawInputButton.tintColor = UIColor.App.shopping
            
            speakInputButton.setImage(#imageLiteral(resourceName: "btn_mic_filled").withRenderingMode(.alwaysTemplate), for: .normal)
            speakInputButton.tintColor = UIColor.App.actionColor
            
            changeInputView(viewToHide: drawInputView, viewToAppear: speakInputView)
        }
    }
    
    @IBAction func reset() {
        moneyValueLabel.text = currencyStr(0)
        drawInputView.cedulesArray = []
        drawInputView.coinsArray = []
    }
    
    func changeInputView(viewToHide: UIView, viewToAppear: UIView) {
        UIView.animate(withDuration: 0.125, animations: {
            viewToHide.transform = CGAffineTransform(translationX: 0, y: 1000)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.125, animations: {
                viewToAppear.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        })
    }

    @objc func confirmAndMoveOn() {
        guard let text = moneyValueLabel.text else { return }
        if !text.isEqual(currencyStr(0)) && !text.isEqual("R$ ,") && !text.isEqual("$ ,") {
            if calculateValue(fromArray: inputedMoney) >= Float(text
                .replacingOccurrences(of: "R$ ", with: "")
                .replacingOccurrences(of: "$ ", with: "")
                .replacingOccurrences(of: ",", with: ".")) ?? 0 {
                let howToPayVC = HowToPayVC()
                howToPayVC.inputedMoneyStr = inputedMoneyStr
                howToPayVC.inputedMoney = round(array: inputedMoney)
                howToPayVC.totalValue = text
                navigationController?.pushViewController(howToPayVC, animated: true)
            }
        }
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func startHearing() {
        inputOptionSelected(speakInputButton)
        speakInputView.startHearing()
    }
    
    func stopHearing() {
        speakInputView.stopHearing()
    }
}
