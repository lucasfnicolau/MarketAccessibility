//
//  ErrorAnimationView.swift
//  MarketAccessibility
//
//  Created by Guilherme Enes on 05/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

class ErrorAnimationView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func startAnimation() {
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 80, y: UIScreen.main.bounds.height / 3))
        bezier.addLine(to: CGPoint(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height / 1.5))

        bezier.move(to: CGPoint(x: UIScreen.main.bounds.width - 80, y: UIScreen.main.bounds.height / 3))
        bezier.addLine(to: CGPoint(x: 80, y: UIScreen.main.bounds.height / 1.5))

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.App.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 40
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round

        let anim = CABasicAnimation(keyPath: KeyPath.strokeEnd.rawValue)
        anim.duration = 1.0
        anim.fromValue = 0

        let anim2 = CABasicAnimation(keyPath: KeyPath.strokeEnd.rawValue)
        anim2.duration = 1.0
        anim2.fromValue = 0

        let animGroup = CAAnimationGroup()
        animGroup.animations = [anim, anim2]
        animGroup.duration = 1

        shapeLayer.speed = 1.0
        shapeLayer.path = bezier.cgPath
        self.layer.addSublayer(shapeLayer)

        shapeLayer.add(anim, forKey: Key.checkAnim.rawValue)
    }

}
