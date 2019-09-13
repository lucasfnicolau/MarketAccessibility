//
//  MoneyVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 23/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit
import AVFoundation

class MoneyVC: UIViewController, AVAudioPlayerDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var moneyInputView: MoneyInputView!
    var inputedMoneyCollectionView: UICollectionView!
    var collectionViewHandler: MoneyVCCollectionHandler!
    var defaults: UserDefaults!
    var helpAudio: AVAudioPlayer?
    var helpButton: LargerTouchAreaButton!

    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaults = UserDefaults()
        navigationController?.navigationBar.tintColor = UIColor.App.actionColor
        navigationController?.navigationBar.barTintColor = UIColor.App.money
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        trashButton.tintColor = UIColor.App.actionColor
        
        let continueBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "continue"), style: .done, target: self,
                                          action: #selector(confirmAndMoveOn))
        continueBtn.accessibilityLabel = NSLocalizedString(LocalizedString.continueBtn.rawValue, comment: "")
        navigationItem.setRightBarButton(continueBtn, animated: true)
        
        guard let btnImage = trashButton.imageView?.image else { return }
        trashButton.setImage(btnImage.withRenderingMode(.alwaysTemplate), for: .normal)
        trashButton.accessibilityLabel = NSLocalizedString(LocalizedString.trash.rawValue, comment: "")
        
        collectionViewHandler = MoneyVCCollectionHandler()
        collectionViewHandler.parentVC = self
        collectionViewHandler.defaults = defaults

        setMoneyInput()
        helpButton = addHelpButton(forVC: self, onTopOf: moneyInputView)
        helpButton.accessibilityLabel = NSLocalizedString(LocalizedString.help.rawValue, comment: "")
        setInputedMoneyCollectionView()
        
        inputedMoneyCollectionView.delegate = collectionViewHandler
        inputedMoneyCollectionView.dataSource = collectionViewHandler
        
        self.view.backgroundColor = UIColor.App.money
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        moneyValueLabel.text = defaults.string(forKey: Key.moneyVCText.rawValue) ?? currencyStr(0)
        guard let floatArray = defaults.array(forKey: Key.moneyVCInputedMoney.rawValue) as? [Float] else { return }
        collectionViewHandler.inputedMoney = floatArray
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
        
        guard let font = UIFont(name: "Avenir", size: 22) else { return }
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.App.white,
            NSAttributedString.Key.font: font
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = UIColor.App.actionColor
        navigationController?.navigationBar.barTintColor = UIColor.App.money
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = NSLocalizedString(LocalizedString.myMoney.rawValue, comment: "")
        self.view.backgroundColor = UIColor.App.money
        
        trashButton.tintColor = UIColor.App.actionColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func confirmAndMoveOn() {
        if !collectionViewHandler.inputedMoney.isEmpty {
            helpButton.setImage(#imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate), for: .normal)
            helpAudio?.stop()
            
            let animationVC = AnimationVC()
            navigationController?.pushViewController(animationVC, animated: true)
        } else {
            let popupVC = PopupVC()
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.modalPresentationStyle = .custom
            popupVC.popupImages = [#imageLiteral(resourceName: "arrow_down1"), #imageLiteral(resourceName: "arrow_down2"), #imageLiteral(resourceName: "arrow_down1"), #imageLiteral(resourceName: "arrow_down2")]
            self.navigationController?.present(popupVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func reset() {
        collectionViewHandler.inputedMoney = []
        inputedMoneyCollectionView.reloadData()
        collectionViewHandler.calculateValue()
    }

    func setMoneyInput() {

        moneyInputView = MoneyInputView(frame: .zero, withSelectedColor: UIColor.App.actionColor,
                                        andUnselectedColor: UIColor.App.money)
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
                .constraint(equalTo: moneyInputView
                    .topAnchor, constant: -30 / SESize.width * UIScreen.main.bounds.width - 16)

            ])
    }
    
    override func playHelpAudio(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate) {
            sender.setImage(#imageLiteral(resourceName: "stop").withRenderingMode(.alwaysTemplate), for: .normal)
            guard let path = Bundle.main.path(forResource: Audio.moneyVC.rawValue, ofType: "wav") else { return }
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
