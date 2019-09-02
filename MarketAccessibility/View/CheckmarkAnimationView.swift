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
        bezier.move(to: CGPoint(x: 60, y: UIScreen.main.bounds.height / 2))
        bezier.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 1.6))
        bezier.addLine(to: CGPoint(x: UIScreen.main.bounds.width - 60, y: UIScreen.main.bounds.height / 3.6))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.App.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 30
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        
        let anim = CABasicAnimation(keyPath: KeyPath.strokeEnd.rawValue)
        anim.duration = 1.5
        anim.fromValue = 0
        
        shapeLayer.speed = 1.0
        shapeLayer.path = bezier.cgPath
        self.layer.addSublayer(shapeLayer)
        
        shapeLayer.add(anim, forKey: Key.checkAnim.rawValue)
    }
}
