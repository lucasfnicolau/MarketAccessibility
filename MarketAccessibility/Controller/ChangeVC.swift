//
//  ChangeVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 31/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit
import AVFoundation

class ChangeVC: UIViewController, AVAudioPlayerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    var change: Float = 0
    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var collectionViewHandler: ChangeVCCollectionHandler!
    var inputedMoney: Float = 0
    var totalValue: Float = 0
    var continueBtn: UIButton!
    var backBtn: UIButton!
    var stackView: UIStackView!
    var change2: Float = 0
    var helpButton: LargerTouchAreaButton!
    var helpAudio: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        change = roundChange(inputedMoney - totalValue)
        let changeStr = currencyStr(change)
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        navigationController?.navigationBar.topItem?.title = " "
        let continueBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "continue"), style: .done, target: self,
                                          action: #selector(confirmAndMoveOn))
        continueBtn.accessibilityLabel = NSLocalizedString(LocalizedString.continueBtn.rawValue, comment: "")
        navigationItem.setRightBarButton(continueBtn, animated: true)
        
        guard let btnImage = trashButton.imageView?.image else { return }
        trashButton.setImage(btnImage.withRenderingMode(.alwaysTemplate), for: .normal)
        trashButton.accessibilityLabel = NSLocalizedString(LocalizedString.trash.rawValue, comment: "")
        
        navigationItem.title = "\(NSLocalizedString(LocalizedString.change.rawValue, comment: "")): \(changeStr)"
        
        collectionViewHandler = ChangeVCCollectionHandler()
        collectionViewHandler.parentVC = self
        
        setMoneyInput()
        helpButton = addHelpButton(forVC: self, onTopOf: moneyInputView)
        helpButton.accessibilityLabel = NSLocalizedString(LocalizedString.help.rawValue, comment: "")
        setInputedMoneyCollectionView()
        
        inputedMoneyCollectionView.delegate = collectionViewHandler
        inputedMoneyCollectionView.dataSource = collectionViewHandler
        
        collectionViewHandler.calculateValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let font = UIFont(name: "Avenir", size: 22) else { return }
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.white,
            NSAttributedString.Key.font: font
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = UIColor.App.actionColor
        navigationController?.navigationBar.barTintColor = UIColor.App.change
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.App.change
        
        trashButton.tintColor = UIColor.App.actionColor
    }
    
    @objc func confirmAndMoveOn() {
        helpButton.setImage(#imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate), for: .normal)
        helpAudio?.stop()
        
        if String(format: "%.2f", calculateValue(fromArray: collectionViewHandler.inputedMoney))
            .isEqual(String(format: "%.2f", change)) {
            let animationVC = AnimationVC()
            animationVC.step = 1
            navigationController?.pushViewController(animationVC, animated: true)
        } else {
            let animationVC = AnimationVC()
            animationVC.step = 2
            navigationController?.pushViewController(animationVC, animated: true)
        }
        
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reset() {
        collectionViewHandler.inputedMoney = []
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
    }
    
    func setMoneyInput() {
        
        moneyInputView = MoneyInputView(frame: .zero, withSelectedColor: UIColor.App.actionColor,
                                        andUnselectedColor: UIColor.App.change)
        moneyInputView.moneyVCDelegate = collectionViewHandler
        moneyInputView.backgroundColor = UIColor.App.background
        
        self.view.addSubview(moneyInputView)
        
        moneyInputView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            moneyInputView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            moneyInputView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            moneyInputView.heightAnchor.constraint(equalToConstant: (isSE() ? 205 : 230)),
            moneyInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            
            ])
        moneyValueLabel.text = currencyStr(0)
        
    }
    
    func setInputedMoneyCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        inputedMoneyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        inputedMoneyCollectionView.backgroundColor = .clear
        inputedMoneyCollectionView.register(InputedMoneyCollectionCell.self,
                                            forCellWithReuseIdentifier: Identifier.inputedMoneyCollectionCell.rawValue)
        inputedMoneyCollectionView.delaysContentTouches = false
        self.view.addSubview(inputedMoneyCollectionView)
        
        inputedMoneyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputedMoneyCollectionView.topAnchor.constraint(equalTo: moneyValueLabel.bottomAnchor, constant: 16),
            inputedMoneyCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            inputedMoneyCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            inputedMoneyCollectionView.bottomAnchor
                .constraint(equalTo: self.moneyInputView
                    .topAnchor, constant: -30 / SESize.width * UIScreen.main.bounds.width - 16)
            
            ])
    }
    
    override func playHelpAudio(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate) {
            sender.setImage(#imageLiteral(resourceName: "stop").withRenderingMode(.alwaysTemplate), for: .normal)
            guard let path = Bundle.main.path(forResource: Audio.changeVC.rawValue, ofType: "wav") else { return }
            let url = URL(fileURLWithPath: path)
            
            let popupVC = PopupVC()
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.modalPresentationStyle = .custom
            popupVC.popupImages = [#imageLiteral(resourceName: "volume1"), #imageLiteral(resourceName: "volume2"), #imageLiteral(resourceName: "volume3")]
            self.navigationController?.present(popupVC, animated: true, completion: nil)
            
            do {
                helpAudio = try AVAudioPlayer(contentsOf: url)
                try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
                helpAudio?.delegate = self
                helpAudio?.numberOfLoops = 0
                helpAudio?.play()
            } catch let error {
                print(error)
                
            }
        } else {
            sender.setImage(#imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate), for: .normal)
            helpAudio?.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        helpButton.setImage(#imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate), for: .normal)
    }
}
