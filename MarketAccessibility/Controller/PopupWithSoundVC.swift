//
//  PopupWithSoundVC.swift
//  MarketAccessibility
//
//  Created by Lucas Fernandez Nicolau on 12/09/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//

import UIKit
import AVFoundation

class PopupWithSoundVC: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var popupImageView: UIImageView!
    var popupImage: UIImage?
    var popupImages = [UIImage]()
    var backgroundIsVisible = true
    var helpAudio: AVAudioPlayer?
    var audioName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !backgroundIsVisible {
            self.view.backgroundColor = .clear
        }

        popupImageView.image = popupImage

        guard let path = Bundle.main.path(forResource: audioName, ofType: "wav") else { return }
        let url = URL(fileURLWithPath: path)

        do {
            helpAudio = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
            helpAudio?.delegate = self
            helpAudio?.numberOfLoops = 0
            helpAudio?.play()
        } catch let error {
            print(error)
        }
    }

    @objc func dismissPopup() {
        self.dismiss(animated: true, completion: nil)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
}
