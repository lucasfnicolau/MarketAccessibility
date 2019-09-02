//
//  AnimationVC.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
// swiftlint:disable trailing_whitespace

import UIKit

class AnimationVC: UIViewController {

    @IBOutlet weak var animationOutlet: UIImageView!
    var animationList: [UIImage] = []
    var step = 0
    var inputedMoneyStr = ""
    var inputedMoney = [Float]()

    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.App.money
        
        setStackView()
        
        if step == 0 {
            setImageViewAnimation()
        } else {
            setCheckmarckAnimation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrs = [
            NSAttributedString.Key.foregroundColor: (step == 0 ? UIColor.App.money : UIColor.App.shopping)
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = true
    }
    
    @objc func confirmAndMoveOn() {
        let shoppingVC = ShoppingVC()
        shoppingVC.inputedMoneyStr = inputedMoneyStr
        shoppingVC.inputedMoney = inputedMoney
        navigationController?.pushViewController(shoppingVC, animated: true)
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }

    func setImageViewAnimation() {
        for counter in 1...6 {
            guard let image = UIImage(named: "Andando\(counter)") else { return }
            animationList.append(image)
        }
        
        for counter in (1...6).reversed() {
            guard let image = UIImage(named: "Andando\(counter)") else { return }
            animationList.append(image)
        }
        
        animationOutlet.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationOutlet.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            animationOutlet.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            animationOutlet.widthAnchor.constraint(equalToConstant: 0.6 * animationOutlet.frame.width),
            animationOutlet.heightAnchor.constraint(equalToConstant: 0.6 * animationOutlet.frame.height)
        ])
        
        animationOutlet.animationImages = animationList
        animationOutlet.animationDuration = 1.25
        animationOutlet.animationRepeatCount = -1
        
        animationOutlet.startAnimating()
    }
    
    func setCheckmarckAnimation() {
        let animView = CheckmarkAnimationView(frame: .zero)
        self.view.addSubview(animView)
        
        animView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            animView.topAnchor.constraint(equalTo: self.view.topAnchor),
            animView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            animView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        animView.startAnimation()
    }
    
    func setStackView() {
        let backBtn = UIButton(frame: .zero)
        backBtn.setImage(#imageLiteral(resourceName: "back_1"), for: .normal)
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
            
            stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 48),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -48),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
}
