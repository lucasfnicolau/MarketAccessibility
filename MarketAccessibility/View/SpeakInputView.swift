//
//  SpeakImputView.swift
//  MarketAccessibility
//
//  Created by Rayane Xavier on 30/08/19.
//  Copyright © 2019 Lucas Fernandez Nicolau. All rights reserved.
//
// swiftlint:disable trailing_whitespace
// swiftlint:disable identifier_name

import Foundation
import UIKit
import Speech

class SpeakInputView: UIView, SFSpeechRecognizerDelegate {
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: Identifier.ptBr.rawValue))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    weak var shoppingVCDelegate: ShoppingVCDelegate!
    var waveSoundImage: UIImage!
    var waves: WaveAnimationView!
    var micButton: MicButton!
    
    init(frame: CGRect, withDelegate delegate: ShoppingVCDelegate) {
        super.init(frame: frame)
        self.shoppingVCDelegate = delegate
        setMicButton()
        setWaves()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setMicButton() {
        micButton = MicButton(frame: .zero)
        micButton.setImage(#imageLiteral(resourceName: "btn_mic_outline").withRenderingMode(.alwaysTemplate), for: .normal)
        micButton.tintColor = UIColor.App.actionColor
        micButton.delegate = shoppingVCDelegate
        self.addSubview(micButton)
        
        micButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            micButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            micButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            micButton.widthAnchor.constraint(equalToConstant: 50),
            micButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    func setWaves() {
        waves = WaveAnimationView(frame: .zero)
        self.addSubview(waves)
        
        waves.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waves.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            waves.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            waves.trailingAnchor.constraint(equalTo: micButton.leadingAnchor, constant: -8),
            waves.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        waves.stopAnimation()
        
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
    
    func checkTextRecognized(text: String) {
        var finalText = ""
        var words = text.uppercased().split(separator: " ")
        for i in 0 ..< words.count {
            words[i] = getNumberFrom(string: String(words[i]).uppercased())
            
            if words[i].starts(with: "R$") {
                finalText = "\(words[i].replacingOccurrences(of: "R$", with: "R$ "))"
                break
            } else if words[i].contains(",") {
                let numbers = words[i].split(separator: ",")
                if numbers.count == 2 && Int(numbers[0]) != nil
                    && Int(numbers[1]) != nil {
                    finalText = "R$ \(numbers[0]),\(numbers[1])"
                    break
                }
            } else if words[i].contains("H") {
                var numbers = words[i].split(separator: "H")
                
                if i - 1 >= 0 {
                    guard let num1 = Int(words[i - 1]),
                        let num2 = Int(numbers[0]) else { return }
                    numbers[0] = "\(num1 + num2)"
                }
                
                if numbers.count == 2 && Int(numbers[0]) != nil
                    && Int(numbers[1]) != nil {
                    finalText = "R$ \(numbers[0]),\(numbers[1])"
                    break
                }
            } else if words[i].contains("E") {
                if i - 1 >= 0 && i + 1 < words.count
                    && Int(words[i - 1]) != nil
                        && Int(words[i + 1]) != nil {
                    finalText = "R$ \(words[i - 1]),\(words[i + 1])"
                    break
                }
            }
        }

        self.shoppingVCDelegate.updateLabel(withValue: finalText != "" ? finalText : currencyStr(0))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startHearing() {
        waves.startAnimation()

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?
            .recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                var isFinal = false
                                                            
                if result != nil {
                    guard let result = result else { return }
                    self.checkTextRecognized(text: result
                        .bestTranscription.formattedString)
                    isFinal = result.isFinal
                }
                                                            
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024,
                             format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return
        }
    }
    
    func stopHearing() {
        waves.stopAnimation()
        
        DispatchQueue.main.async { [unowned self] in
            self.recognitionTask?.cancel()
            self.recognitionTask?.finish()
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.soloAmbient)
            } catch {
                
            }
        }
    }
}
