//
//  AnimationVC.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class AnimationVC: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var animationOutlet: UIImageView!
    var animationList: [UIImage] = []
    var step = 0
    var inputedMoneyStr = ""
    var inputedMoney = [Float]()
    var lastVC: UIViewController!
    var timer: Timer!
    var count = 0

    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let attrs = [
            NSAttributedString.Key.foregroundColor: (step == 0 ? UIColor.App.money : UIColor.App.shopping)
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = true
        
        if step == 0 {
            view.backgroundColor = UIColor.App.money
            setImageViewAnimation()
        } else if step == 1 {
            view.backgroundColor = UIColor.App.money
            setCheckmarkAnimation()
        } else {
            view.backgroundColor = UIColor.App.error
            setErrorAnimation()
        }
        
    }
    
    @objc func confirmAndMoveOn() {
        if step == 0 {
            let shoppingVC = ShoppingVC()
            shoppingVC.inputedMoneyStr = inputedMoneyStr
            shoppingVC.inputedMoney = inputedMoney
            navigationController?.pushViewController(shoppingVC, animated: true)
            guard let vcs = navigationController?.viewControllers else { return }
            for index in 0 ..< vcs.count where vcs[index] == self {
                navigationController?.viewControllers.remove(at: index)
            }
        } else if step == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
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
        animationOutlet.animationRepeatCount = 5
        animationOutlet.startAnimating()
        perform(#selector(didFinishAnimating), with: animationOutlet,
                afterDelay: TimeInterval(animationOutlet.animationDuration * 1.5))
    }
    
    @objc func didFinishAnimating() {
        confirmAndMoveOn()
    }
    
    func setCheckmarkAnimation() {
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
        perform(#selector(didFinishAnimating), with: animView,
                afterDelay: TimeInterval(1.5))
    }

    func setErrorAnimation() {
        let animView = ErrorAnimationView(frame: .zero)
        self.view.addSubview(animView)
        
        animView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            animView.topAnchor.constraint(equalTo: self.view.topAnchor),
            animView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            animView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        animView.startAnimation()
        perform(#selector(didFinishAnimating), with: animView,
                afterDelay: TimeInterval(1.5))
    }
    
}
