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
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
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
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("ERROR == %@",error)
        isVoiceInputNow = false
    }
    
    //MARK: Google Speech API
    func callGoogleRecognizeApi(data: NSData) {
        var googleSpeechAPIKey: String = ""
        
        
        //APIキーを読み込み
        if let speechAPIKEY = KeyManager().getValue("GoogleSpeechAPIKey") as? String {
            googleSpeechAPIKey = speechAPIKEY
        }
        
        let urlStr = NSString.localizedStringWithFormat("https://www.google.com/speech-api/v2/recognize?xjerr=1&client=chromium&lang=ja-JP&maxresults=10&pfilter=0&xjerr=1&key=%@", googleSpeechAPIKey)
        let url: NSURL = NSURL(string: urlStr as String)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("audio/l16; rate=16000", forHTTPHeaderField: "Content-Type")
        request.addValue("chromium", forHTTPHeaderField: "client")
        request.HTTPBody = data
        
        NSURLConnection(request: request, delegate: self)
        
        
    }
    
    func startRecord() {
        isVoiceInputNow = true
        self.filePath = self.makeFilePath()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            let settings: NSDictionary = [
                AVFormatIDKey: NSNumber.init(unsignedInt: kAudioFormatLinearPCM),
                AVSampleRateKey: NSNumber.init(float: 16000.0),
                AVNumberOfChannelsKey: NSNumber.init(unsignedInt: 1),
                AVLinearPCMBitDepthKey: NSNumber.init(unsignedInt: 16)
            ]
            do {
                self.recorder = try AVAudioRecorder(URL: NSURL.init(string: self.filePath as String)!, settings: settings as! [String : AnyObject])
                self.recorder.delegate = self
                self.recorder.prepareToRecord()
                self.recorder.recordForDuration(15.0)
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
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let fileName: String = String(format: "%@.wav", formatter.stringFromDate(NSDate()))
        return NSTemporaryDirectory().stringByAppendingString(fileName)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            return
        }
        let data: NSData = NSData(contentsOfFile: self.filePath)!
        self.callGoogleRecognizeApi(data)
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        let weakSelf = self
        dispatch_async(dispatch_get_main_queue(),{
            weakSelf.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioStreamBasicDescription audioStreamBasicDescription: AudioStreamBasicDescription) {
        EZAudioUtilities.printASBD(audioStreamBasicDescription)
    }
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
    }

}
