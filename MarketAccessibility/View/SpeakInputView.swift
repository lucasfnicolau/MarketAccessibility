//
//  SpeakImputView.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace

import Foundation
import UIKit
import Speech

class SpeakInputView: UIView, SFSpeechRecognizerDelegate {
    
//    weak var speakValueVCDelegate: SpeakVCDelegate!
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: Identifier.ptBr.rawValue))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    var waveSoundImage: UIImage!
    var recordButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setRecordButton() {
        recordButton = UIButton(frame: .zero)
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                break
                
            case .denied:
                break
                
            case .restricted:
                break
                
            case .notDetermined:
                break
                
            default:
                break
            }
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWaveSoundImage() {
        
    }
    
}
