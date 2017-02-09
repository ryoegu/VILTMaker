//
//  SpeechExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/18.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import Foundation
import EZAudio
import Speech

extension ViewController {

    func startRecord() {
        UIView.animate(withDuration: TimeInterval(CGFloat(0.5)), animations: {
            self.audioPlot.alpha = 1
        })
        
        do {
            print("start recording")
            try startRecording()
        }
        catch let error {
            print(error.localizedDescription)
            UIView.animate(withDuration: TimeInterval(CGFloat(0.5)), animations: { () -> Void in
                self.audioPlot.alpha = 0
                //                self.voiceInputButton.isHidden = true
                self.afterChangingTextView.isHidden = false
            })
        }
        
        

    }
    
    func stopRecord() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        
        UIView.animate(withDuration: TimeInterval(CGFloat(0.5)), animations: { () -> Void in
            self.audioPlot.alpha = 0
            //                self.voiceInputButton.isHidden = true
            self.afterChangingTextView.isHidden = false
        })
        
        
    }
    
    //MARK: Speech API
    
    func requestAPI() {
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            
            OperationQueue.main.addOperation {
                
                switch status {
                    
                case .authorized: print("authorized")
                case .denied: print("denied")
                case .restricted: print("restricted")
                case .notDetermined: print("notDetermined")
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        refreshTask()
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let inputNode = audioEngine.inputNode else {
            
            fatalError("Audio Engine has no inputNode")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            
            fatalError("Unable to create a SFSpeechAudioBufferRecognition object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
            
            guard let `self` = self else { return }
            
            var isFinal = false
            if let result = result {
                /* VOICE RECOGNITION RESULT */
                print("VOICE RECOG===\(result.bestTranscription.formattedString)")
                self.afterChangingTextView.text = result.bestTranscription.formattedString

                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "体型", with: "台形")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "問題に", with: "問題2")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "センチメートル", with: "cm")

                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "Α", with: "A")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "α", with: "A")
                
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "β", with: "B")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "デルタ", with: "D")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "ε", with: "E")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "しいた", with: "C")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "した", with: "C")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "ファイ", with: "F")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "Φ", with: "F")
                self.afterChangingTextView.text = self.afterChangingTextView.text.replacingOccurrences(of: "掃除", with: "相似")
                
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
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            
            self.recognitionRequest?.append(buffer)
        })
        
        try startAudioEngine()
    }
    
    private func refreshTask() {
        
        if let recognitionTask = recognitionTask {
            
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }
    
    private func startAudioEngine() throws {
        
        audioEngine.prepare()
        
        try audioEngine.start()
    }
    
    //MARK: EZMicrophone, Audio Plot Methods
    
    func audioPlotInit() {
        //波形
        do {
            let session: AVAudioSession = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            audioPlot.backgroundColor = ConstColor.main
            audioPlot.color = ConstColor.white
            audioPlot.plotType = EZPlotType.buffer
            audioPlot.shouldFill = true
            audioPlot.shouldMirror = true
            microphone = EZMicrophone(delegate: self)
            microphone.startFetchingAudio()
        }catch{
            
        }
    }

    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        let weakSelf = self
        DispatchQueue.main.async(execute: {
            weakSelf.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(_ microphone: EZMicrophone!, hasAudioStreamBasicDescription audioStreamBasicDescription: AudioStreamBasicDescription) {
        EZAudioUtilities.printASBD(audioStreamBasicDescription)
    }
    func microphone(_ microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) { }
}

// MARK: - SFSpeechRecognizerDelegate

extension ViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
}
