//
//  PopupVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 11/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import UIKit

class PopupVC: UIViewController {
    
    @IBOutlet weak var popupImageView: UIImageView!
    var popupImage: UIImage?
    var popupImages = [UIImage]()
    var backgroundIsVisible = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !backgroundIsVisible {
            self.view.backgroundColor = .clear
        }
        
        if popupImages.isEmpty {
            popupImageView.image = popupImage
            perform(#selector(dismissPopup), with: popupImageView,
                    afterDelay: TimeInterval(0.75))
        } else {
            setImageViewAnimation()
        }
    }
    
    func setImageViewAnimation() {
        popupImageView.animationImages = popupImages
        popupImageView.animationDuration = 0.75
        popupImageView.animationRepeatCount = 1
        popupImageView.startAnimating()
        perform(#selector(dismissPopup), with: popupImageView,
                afterDelay: TimeInterval(0.75))
    }
    
    @objc func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }
}
