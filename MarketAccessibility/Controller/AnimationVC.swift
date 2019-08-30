//
//  AnimationVC.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

//class AnimationVC: UIViewController {
//
//    @IBOutlet weak var animationOutlet: UIImageView!
//    var animationList:[UIImage] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.App.money
//        
//        animationScene()
//    }
//    func animationScene() {
//        for counter in 1...6 {
//            animationList.append( UIImage(named: "Andando\(6-counter)")!)
//        }
//
//        for counter in 0...5 {
//            animationList.append(UIImage(named: "Andando\(counter)")!)
//        }
//    }
//
//    @objc func animationImageSelected() {
//        animationOutlet.animationImages = animationList
//        animationOutlet.animationDuration = 2
//        animationOutlet.animationRepeatCount = 1
//
//        animationOutlet.startAnimating()
//    }
//
//    func setConstrains() {
//        animationOutlet.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            animationOutlet.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            animationOutlet.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            ])
//    }
//    /*
    // MARK: - Navigation

//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */

//}
