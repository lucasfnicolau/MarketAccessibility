//
//  HowToPayVC.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 02/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name

import UIKit
import AVFoundation

class HowToPayVC: UIViewController, AVAudioPlayerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var collectionViewHandler: HowToPayVCCollectionHandler!
    var inputedMoneyStr = ""
    var totalValueFloat: Float = 0
    var totalValue = ""
    var inputedMoney = [Float]()
    var paymentMoney = [Float]()
    var payment = [Float]()
    var bestPayment = [Float]()
    var hasReachedResult = false
    var minDiffs = [Float]()
    var helpButton: LargerTouchAreaButton!
    var helpAudio: AVAudioPlayer?
    @IBOutlet weak var moneyValueLabel: UILabel!
    @IBOutlet weak var moneyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString(LocalizedString.howToPay.rawValue, comment: "")
        
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        navigationController?.navigationBar.topItem?.title = " "
        let continueBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "continue"), style: .done, target: self,
                                          action: #selector(confirmAndMoveOn))
        continueBtn.accessibilityLabel = NSLocalizedString(LocalizedString.continueBtn.rawValue, comment: "")
        navigationItem.setRightBarButton(continueBtn, animated: true)
        
        guard let totalValueFloat = Float(currency: totalValue) else { return }
        self.totalValueFloat = Float(String(format: "%.2f", totalValueFloat)) ?? 0.0
        
        collectionViewHandler = HowToPayVCCollectionHandler()
        collectionViewHandler.parentVC = self

        moneyCollectionView.delegate = collectionViewHandler
        moneyCollectionView.dataSource = collectionViewHandler

        moneyCollectionView.register(HowToPayCollectionCell.self,
                                     forCellWithReuseIdentifier: Identifier.howToPayCollectionCell.rawValue)
        
        let resultArray = findSubsetSum(inputedMoney, targetSum: totalValueFloat)
        payment = resultArray.isEmpty ? calculatePayment(fromValues: payment, atIndex: 0) : resultArray
        
        moneyValueLabel.text = String(format: "R$ %.2f", calculateValue(fromArray: payment))
            .replacingOccurrences(of: ".", with: ",")

        helpButton = addHelpButton(forVC: self, under: moneyCollectionView)
        helpButton.accessibilityLabel = NSLocalizedString(LocalizedString.help.rawValue, comment: "")
        
        collectionViewHandler.inputedMoney = payment
        moneyCollectionView.reloadData()
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
        navigationController?.navigationBar.barTintColor = UIColor.App.shopping
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = NSLocalizedString(LocalizedString.howToPay.rawValue, comment: "")
        self.view.backgroundColor = UIColor.App.shopping
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func confirmAndMoveOn() {
        helpButton.setImage(#imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate), for: .normal)
        helpAudio?.stop()
        
        if String(format: "%.2f", calculateValue(fromArray: payment)).isEqual(String(format: "%.2f", totalValueFloat))
            || roundChange(calculateValue(fromArray: payment) - totalValueFloat) <= 0 {
            let animationVC = AnimationVC()
            animationVC.step = 1
            navigationController?.pushViewController(animationVC, animated: true)
        } else {
            let changeVC = ChangeVC()
            changeVC.inputedMoney = calculateValue(fromArray: payment)
            changeVC.totalValue = totalValueFloat
            navigationController?.pushViewController(changeVC, animated: true)
        }
    }
    
    @objc func stopAndMoveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func calculatePayment(fromValues values: [Float], atIndex index: Int) -> [Float] {
        
        var minDiff = Float.infinity
        var bestPayment = [Float]()
        
        for i in 0 ..< inputedMoney.count {
            var payment = [Float]()
            
            payment.append(inputedMoney[i])
            var sum = inputedMoney[i].roundTo(places: 2)
            let index = (i <= inputedMoney.count - 1 ? i + 1 : i)
            for j in index ..< inputedMoney.count {
                if inputedMoney[i] < totalValueFloat {
                    sum += inputedMoney[j]
                    payment.append(inputedMoney[j])
                }
                
                if sum > totalValueFloat ||
                    String(format: "%.2f", sum).isEqual(String(format: "%.2f", totalValueFloat)) {
                    if calculateValue(fromArray: payment) - totalValueFloat < minDiff {
                        minDiff = calculateValue(fromArray: payment) - totalValueFloat
                        bestPayment = payment
                        
                        sum = inputedMoney[i]
                        payment = [inputedMoney[i]]
                    }
                }
            }
            
            if index == inputedMoney.count {
                if sum > totalValueFloat ||
                    String(format: "%.2f", sum).isEqual(String(format: "%.2f", totalValueFloat)) {
                    if calculateValue(fromArray: payment) - totalValueFloat < minDiff {
                        minDiff = calculateValue(fromArray: payment) - totalValueFloat
                        bestPayment = payment
                        
                        sum = inputedMoney[i]
                        payment = [inputedMoney[i]]
                    }
                }
            }
        }
        
        return bestPayment
    }
    
    override func playHelpAudio(_ sender: UIButton) {
        if sender.imageView?.image == #imageLiteral(resourceName: "help").withRenderingMode(.alwaysTemplate) {
            sender.setImage(#imageLiteral(resourceName: "stop").withRenderingMode(.alwaysTemplate), for: .normal)
            guard let path = Bundle.main.path(forResource: Audio.howToPayVC.rawValue, ofType: "wav") else { return }
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
