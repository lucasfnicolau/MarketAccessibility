//
//  ChangeVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 31/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class ChangeVC: UIViewController {
    
    @IBOutlet weak var moneyValueLabel: UILabel!
    var inputedMoneyStr: String = ""
    var totalValueStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFlowStackView()
        
        guard let inputedMoney = Float(inputedMoneyStr.replacingOccurrences(of: "R$ ", with: "")
            .replacingOccurrences(of: ",", with: ".")) else { return }
        guard let totalValue = Float(totalValueStr.replacingOccurrences(of: "R$ ", with: "")
            .replacingOccurrences(of: ",", with: ".")) else { return }
        
        let change = inputedMoney - totalValue
        moneyValueLabel.text = "R$ \(change)".replacingOccurrences(of: ".", with: ",")
    }
    
    @objc func confirmAndMoveOn() {
        let animationVC = AnimationVC()
        animationVC.step = 1
        navigationController?.pushViewController(animationVC, animated: true)
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setFlowStackView() {
        let backBtn = UIButton(frame: .zero)
        backBtn.setImage(#imageLiteral(resourceName: "back_2"), for: .normal)
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
