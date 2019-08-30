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
    var img = UIImage(named: "Andando1.png")

    override func viewDidLoad() {
        view.backgroundColor = UIColor.App.money

        animationScene()
        animationImageSelected()
        setConstrains()
    }
    
        func animationScene() {
            
            for counter in 1...6 {
                guard let image = UIImage(named: "Andando\(counter)") else { return }
                animationList.append(image)
            }
            
            for counter in (1...6).reversed() {
                guard let image = UIImage(named: "Andando\(counter)") else { return }
                animationList.append(image)
            }
        }

        func animationImageSelected() {
            animationOutlet.animationImages = animationList
            animationOutlet.animationDuration = 1.25
            animationOutlet.animationRepeatCount = -1

            animationOutlet.startAnimating()
        }

        func setConstrains() {
            animationOutlet.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                animationOutlet.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                animationOutlet.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
                ])
    }
}
