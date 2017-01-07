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
        
        isVoiceInputNow = true
        do {
            print("start recording")
            try startRecording()
        }
        catch let error {
            isVoiceInputNow = false
            print(error.localizedDescription)
            }

    }
    
    func stopRecord() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isVoiceInputNow = false
        
        
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
                print(result.bestTranscription.formattedString)
                self.afterChangingTextView.text = result.bestTranscription.formattedString
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
    
    //MARK: EZMicrophone
    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        let weakSelf = self
        DispatchQueue.main.async(execute: {
            weakSelf.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(_ microphone: EZMicrophone!, hasAudioStreamBasicDescription audioStreamBasicDescription: AudioStreamBasicDescription) {
        EZAudioUtilities.printASBD(audioStreamBasicDescription)
    }
    func microphone(_ microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
    }
}

// MARK: - SFSpeechRecognizerDelegate

extension ViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
    }
}
