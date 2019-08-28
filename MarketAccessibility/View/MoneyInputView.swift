//
//  MoneyInputView.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 26/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit

protocol MoneyInputViewDelegate: class {
    func didSelect(value: Float)
    func delete(onPosition position: Int)
    func segmentedButtonChanged(to name: String)
}

@IBDesignable
class MoneyInputView: UIView {

    var segmentedStackView: SegmentedStackView!
    var moneyCollectionView: UICollectionView!
    var cedules: [Float] = [2.0, 5.0, 10.0, 20.0, 50.0, 100.0]
    var coins: [Float] = [0.05, 0.10, 0.25, 0.50, 1.0]
    var selectedData = [Float]()
    weak var moneyVCDelegate: MoneyVCDelegate!

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        selectedData = cedules
        setMoneyInput()
        moneyCollectionView.delegate = self
        moneyCollectionView.dataSource = self

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
        ceduleButton.tintColor = UIColor.App.segmentedSelected

        let coinButton = SegmentedStackButton(withName: SegmentedStackOption.coins.rawValue)

        coinButton.setImage(#imageLiteral(resourceName: "CoinOption").withRenderingMode(.alwaysTemplate), for: .normal)
        coinButton.tintColor = UIColor.App.segmentedUnselected

        segmentedStackView = SegmentedStackView(withViews: [ceduleButton, coinButton])

        ceduleButton.segmentedStackViewDelegate = segmentedStackView
        coinButton.segmentedStackViewDelegate = segmentedStackView

        self.addSubview(moneyCollectionView)
        self.addSubview(segmentedStackView)

        moneyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentedStackView.moneyInputViewDelegate = self

        NSLayoutConstraint.activate([
            moneyCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            moneyCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            moneyCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            moneyCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -64),

            segmentedStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            segmentedStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            segmentedStackView.heightAnchor.constraint(equalToConstant: 30),
            segmentedStackView.widthAnchor.constraint(equalToConstant: 150)
            ])
    }
}

extension MoneyInputView: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, MoneyInputViewDelegate {
    func segmentedButtonChanged(to name: String) {

        switch name {
        case SegmentedStackOption.cedules.rawValue:
            selectedData = cedules
        default:
            selectedData = coins
        }
        moneyCollectionView.reloadData()
    }

    func delete(onPosition position: Int) {
        moneyVCDelegate.delete(onPosition: position)
    }

    func didSelect(value: Float) {
        moneyVCDelegate.moneySelected(value: value)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedData.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let moneyCollectionCell  = collectionView.dequeueReusableCell(
            withReuseIdentifier: Identifier.moneyCollectionCell.rawValue,
            for: indexPath) as? MoneyCollectionCell {
            moneyCollectionCell.setImage(fromName: String(selectedData[indexPath.row]))
            moneyCollectionCell.moneyButton.value = selectedData[indexPath.row]
            moneyCollectionCell.moneyButton.delegate = self
            return moneyCollectionCell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        var size = CGSize(width: 0, height: 0)

        if selectedData == cedules {
            size = CGSize(width: UIScreen.main.bounds.width / 3 - 10.0, height: 55)
        } else {
            size = CGSize(width: UIScreen.main.bounds.width / 5 - 10.0,
                          height: UIScreen.main.bounds.width / 5 - 10.0)
        }
        return size
    }

}
