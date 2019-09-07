//
//  MoneyInputView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

protocol MoneyInputViewDelegate: class {
    func didSelect(value: Float)
    func delete(onPosition position: Int)
    func segmentedButtonChanged(to name: String)
}

@IBDesignable
class MoneyInputView: UIView {
    var selectedColor = UIColor.App.money
    var segmentedStackView: SegmentedStackView!
    var moneyCollectionView: UICollectionView!
    weak var moneyVCDelegate: MoneyVCDelegate!
    var moneyInputCollectionHandler: MoneyInputViewCollectionHandler?

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    init(frame: CGRect, withSelectedColor color: UIColor) {
        super.init(frame: frame)

        selectedColor = color
        moneyInputCollectionHandler = MoneyInputViewCollectionHandler()
        moneyInputCollectionHandler?.parentVC = self
        setMoneyInput()
        moneyCollectionView.delegate = moneyInputCollectionHandler
        moneyCollectionView.dataSource = moneyInputCollectionHandler
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // segmented
    func setMoneyInput() {

        // MARK: - criaçao da collection

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        moneyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        moneyCollectionView.backgroundColor = .clear
        moneyCollectionView.register(MoneyCollectionCell.self,
                                     forCellWithReuseIdentifier: Identifier.moneyCollectionCell.rawValue)
        moneyCollectionView.delaysContentTouches = false

        // MARK: - criaçao da custom segmented

        let ceduleButton = SegmentedStackButton(withName: SegmentedStackOption.cedules.rawValue)
        ceduleButton.setImage(#imageLiteral(resourceName: "CeduleOption_Filled").withRenderingMode(.alwaysTemplate), for: .normal)
        
        let coinButton = SegmentedStackButton(withName: SegmentedStackOption.coins.rawValue)
        coinButton.setImage(#imageLiteral(resourceName: "CoinOption").withRenderingMode(.alwaysTemplate), for: .normal)
        
        ceduleButton.tintColor = selectedColor
        coinButton.tintColor = UIColor.App.segmentedUnselected
        
        segmentedStackView = SegmentedStackView(withViews: [ceduleButton, coinButton])

        ceduleButton.segmentedStackViewDelegate = segmentedStackView
        coinButton.segmentedStackViewDelegate = segmentedStackView

        self.addSubview(moneyCollectionView)
        self.addSubview(segmentedStackView)

        moneyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedStackView.moneyInputViewDelegate = moneyInputCollectionHandler
        segmentedStackView.selectedColor = selectedColor

        NSLayoutConstraint.activate([
            moneyCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            moneyCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            moneyCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            moneyCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -64),

            segmentedStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            segmentedStackView.heightAnchor.constraint(equalToConstant: 30),
            segmentedStackView.widthAnchor.constraint(equalToConstant: 150)
            ])
    }
}
