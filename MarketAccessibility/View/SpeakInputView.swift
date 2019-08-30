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
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: Identifier.ptBr.rawValue))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    weak var shoppingVCDelegate: ShoppingVCDelegate!
    var waveSoundImage: UIImage!
    var recordButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setRecordButton()
        recordButton.setImage(UIImage(named: Identifier.microphoneOn.rawValue)?.withRenderingMode(.alwaysTemplate),
                              for: .normal)
    }

    func setRecordButton() {
        recordButton = UIButton(frame: .zero)
        recordButton.tintColor = UIColor.App.money
        self.addSubview(recordButton)
        recordButton.addTarget(self, action: #selector(recordButtonPressed), for: .touchUpInside)
        
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            recordButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            recordButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            recordButton.widthAnchor.constraint(equalToConstant: 60),
            recordButton.heightAnchor.constraint(equalToConstant: 60)
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
    
    func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest,
                                                            resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.shoppingVCDelegate.updateLabel(withValue: result?.bestTranscription.formattedString
                    ?? Number.zero.rawValue)
                guard let result = result else { return }
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
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
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
    }
    
    @objc func recordButtonPressed() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.setImage(UIImage(named: Identifier.microphoneOn.rawValue)?.withRenderingMode(.alwaysTemplate),
                                  for: .normal)
        } else {
            startRecording()
            recordButton.setImage(UIImage(named: Identifier.microphoneOff.rawValue)?.withRenderingMode(.alwaysTemplate),
                                  for: .normal)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWaveSoundImage() {
        
    }
    
}
