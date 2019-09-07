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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setWaves()
    }

    func setWaves() {
        waves = WaveAnimationView(frame: .zero)
        self.addSubview(waves)
        waves.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waves.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            waves.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            waves.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            waves.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
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
        var words = text.split(separator: " ")
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
            try audioSession.setCategory(AVAudioSession.Category.record)
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
                    inputNode.removeTap(onBus: 0)
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
        }
    }
}
