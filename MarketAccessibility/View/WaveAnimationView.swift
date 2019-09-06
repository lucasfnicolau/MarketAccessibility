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
    var views = [UIView]()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setViews() {
        let stackView = UIStackView(frame: .zero)
        setContraints(forView: stackView)
        
        var view = UIView()
        for _ in 0 ..< viewsNumber {
            view = UIView(frame: .zero)
            view.backgroundColor = UIColor.App.segmentedUnselected
            views.append(view)
            setAnimations(forView: view)
            stackView.addArrangedSubview(view)
            view.layer.cornerRadius = view.frame.width / 2
        }
        
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
    }
    
    func setAnimations(forView view: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: CGFloat.random(in: 0.25 ... 1.0))
        }, completion: { (_) in
            self.setAnimations(forView: view)
        })
    }
    
    func setContraints(forView view: UIView) {
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 70),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -70)
        ])
    }
}
