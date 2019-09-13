//
//  WaveAnimationView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 06/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class WaveAnimationView: UIView {
    var viewsNumber = 20
    var stackView: UIStackView!
    var lineView: UIView!
    var views = [UIView]()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setStackView() {
        stackView = UIStackView(frame: .zero)
        self.addSubview(stackView)
        
        stackView.spacing = isSE() ? 8 : 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -70)
        ])
    }
    
    func setAnimations(forView view: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut], animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: CGFloat.random(in: 0.2 ... 1.0))
        }, completion: { (_) in
            self.setAnimations(forView: view)
        })
    }
    
    func startAnimation() {
        if lineView != nil {
            lineView.removeFromSuperview()
        }
        
        var view = UIView()
        for _ in 0 ..< viewsNumber {
            view = UIView(frame: .zero)
            view.backgroundColor = UIColor.App.shopping
            views.append(view)
            setAnimations(forView: view)
            stackView.addArrangedSubview(view)
        }
    }
    
    func stopAnimation() {
        for view in views {
            view.removeFromSuperview()
        }
        
        lineView = UIView(frame: .zero)
        self.addSubview(lineView)
        
        lineView.backgroundColor = UIColor.App.shopping
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            lineView.heightAnchor.constraint(equalToConstant: isSE() ? 3 : 5),
            lineView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
