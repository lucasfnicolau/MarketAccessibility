//
//  CheckmarkAnimationView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class CheckmarkAnimationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startAnimation() {
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 90, y: UIScreen.main.bounds.height / 1.9))
        bezier.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.6))
        bezier.addLine(to: CGPoint(x: UIScreen.main.bounds.width - 90, y: UIScreen.main.bounds.height / 3))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.App.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 40
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        
        let anim = CABasicAnimation(keyPath: KeyPath.strokeEnd.rawValue)
        anim.duration = 0.8
        anim.fromValue = 0
        
        shapeLayer.speed = 1.0
        shapeLayer.path = bezier.cgPath
        self.layer.addSublayer(shapeLayer)
        
        shapeLayer.add(anim, forKey: Key.checkAnim.rawValue)
    }
}
