//
//  SpeechExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/18.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import EZAudio

extension ViewController {
    //NSURLDataDelegate
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        let json = JSON(data: data)
        NSLog("データを受け取りました")
        print(json)
        if var resultString = json["result"][0]["alternative"][0]["transcript"].string {
            //Now you got your value
            NSLog("google result == %@",resultString)
            //音声認識結果をテキストビューに表示
            resultString = changeCharacter(resultString)
            afterChangingTextView.text = resultString
            docomoSpeakModel.speak(resultString)
        }
        isVoiceInputNow = false
    }
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("ERROR == \(error)")
        isVoiceInputNow = false
    }
    
    //MARK: Google Speech API
    func callGoogleRecognizeApi(_ data: Data) {
        var googleSpeechAPIKey: String = ""
        
        //APIキーを読み込み
        if let speechAPIKEY = KeyManager().getValue("GoogleSpeechAPIKey") as? String {
            googleSpeechAPIKey = speechAPIKEY
        }
        
        let urlStr = NSString.localizedStringWithFormat("https://www.google.com/speech-api/v2/recognize?xjerr=1&client=chromium&lang=ja-JP&maxresults=10&pfilter=0&xjerr=1&key=%@", googleSpeechAPIKey)
        let url: URL = URL(string: urlStr as String)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("audio/l16; rate=16000", forHTTPHeaderField: "Content-Type")
        request.addValue("chromium", forHTTPHeaderField: "client")
        request.httpBody = data
        
        NSURLConnection(request: request as URLRequest, delegate: self)
        
        
    }
    
    func startRecord() {
        isVoiceInputNow = true
        self.filePath = self.makeFilePath()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            let settings: NSDictionary = [
                AVFormatIDKey: NSNumber.init(value: kAudioFormatLinearPCM as UInt32),
                AVSampleRateKey: NSNumber.init(value: 16000.0 as Float),
                AVNumberOfChannelsKey: NSNumber.init(value: 1 as UInt32),
                AVLinearPCMBitDepthKey: NSNumber.init(value: 16 as UInt32)
            ]
            do {
                self.recorder = try AVAudioRecorder(url: URL.init(string: self.filePath as String)!, settings: settings as! [String : AnyObject])
                self.recorder.delegate = self
                self.recorder.prepareToRecord()
                self.recorder.record(forDuration: 15.0)
            }catch{
            }
        }catch{
        }
    }
    
    func stopRecord() {
        isVoiceInputNow = false
        self.recorder.stop()
    }
    
    func makeFilePath() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let fileName: String = String(format: "%@.wav", formatter.string(from: Date()))
        return NSTemporaryDirectory() + fileName
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            return
        }
        let data: Data = try! Data(contentsOf: URL(fileURLWithPath: self.filePath))
        self.callGoogleRecognizeApi(data)
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
    func microphone(_ microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
    }

}
