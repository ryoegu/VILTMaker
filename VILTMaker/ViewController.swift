//
//  ViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class ViewController: UIViewController, UITextViewDelegate, AVAudioRecorderDelegate, NSURLConnectionDataDelegate {
    
    @IBOutlet var previewQuestionLabel: UILabel!
    @IBOutlet var editQuestionTextView: UITextView!
    @IBOutlet var previewSelectButton: [BorderButton]!
    
    let docomoSpeakModel: SpeakModel = SpeakModel()
    
    var filePath: String!
    var recorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        editQuestionTextView.delegate = self
        //初期値（仮置き）
        previewSelectButton[1].backgroundColor = ConstColor.pink
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectButtonPushed(sender: BorderButton) {
        //1回タップで音声合成。
        var buttonTitle = sender.currentTitle
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("△", withString: "三角形")
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("≡", withString: " 合同 ")
        NSLog("buttonTitle==%@",buttonTitle!)
        
        docomoSpeakModel.speak(buttonTitle!)
        
    }
    //MARK: ダブルタップ処理
    @IBAction func editButton1DoubleTapped(sender: UITapGestureRecognizer) {
        NSLog("Edit Button 1 Double Tapped")
        self.doubleTappedGeneralWithButtonIndex(0)
    }
    @IBAction func editButton2DoubleTapped(sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(1)
    }
    @IBAction func editButton3DoubleTapped(sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(2)
    }
    
    func doubleTappedGeneralWithButtonIndex(index:Int){
        for j in 0...2 {
            previewSelectButton[j].backgroundColor = ConstColor.white
        }
        previewSelectButton[index].backgroundColor = ConstColor.pink
    }
    
    //MARK: TextView処理
    func textViewDidChange(textView: UITextView) {
        previewQuestionLabel.text = textView.text
    }
    
    
    
    @IBAction func voiceInputButtonPushed(sender: UIButton) {
        if sender.selected {
            self.stopRecord()
            NSLog("STOPRECORD")
        }else{
            self.startRecord()
            NSLog("STOPRECORD")
        }
    }
    
    //NSURLDataDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        let json = JSON(data: data)
        NSLog("データを受け取りました")
        print(json)
        if let resultString = json["result"][0]["alternative"][0]["transcript"].string {
            //Now you got your value
            NSLog("google result == %@",resultString)
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("ERROR == %@",error)
    }
    
    //MARK: Google Speech API
    func callGoogleRecognizeApi(data: NSData) {
        NSLog("CALL GOOGLE RECOGNIZE API")
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
        self.filePath = self.makeFilePath()
        do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
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
 
}

