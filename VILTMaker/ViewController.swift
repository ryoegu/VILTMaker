//
//  ViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var previewQuestionLabel: UILabel!
    @IBOutlet var editQuestionTextView: UITextView!
    @IBOutlet var editSelectButton: [BorderButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // DoCoMo開発者ポータルから取得したAPIキーの設定
        if let docomoAPIKEY = KeyManager().getValue("docomoAPIKey") as? String {
            AuthApiKey.initializeAuth(docomoAPIKEY)
        }
        
        editQuestionTextView.delegate = self
        editSelectButton[1].backgroundColor = ConstColor.pink
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectButtonPushed(sender: BorderButton) {
        /*
        //2回タップで、色を変更する。※2回タップ用に残しておく。
        
        sender.backgroundColor = ConstColor.pink
        
        switch sender.tag {
        case 1:
            editSelectButton[1].backgroundColor = ConstColor.white
            editSelectButton[2].backgroundColor = ConstColor.white
        case 2:
            editSelectButton[0].backgroundColor = ConstColor.white
            editSelectButton[2].backgroundColor = ConstColor.white
        default:
            editSelectButton[0].backgroundColor = ConstColor.white
            editSelectButton[1].backgroundColor = ConstColor.white
        }*/
        
        
        //1回タップで音声合成。
        var buttonTitle = sender.currentTitle
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("△", withString: "三角形")
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("≡", withString: " 合同 ")
        NSLog("buttonTitle==%@",buttonTitle!)
        self.playSound(buttonTitle!)
        
    }
    //MARK: ダブルタップ処理
    @IBAction func editButton1DoubleTapped(sender: UITapGestureRecognizer) {
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
            editSelectButton[j].backgroundColor = ConstColor.white
        }
        editSelectButton[index].backgroundColor = ConstColor.pink
    }
    
    //MARK: TextView処理
    func textViewDidChange(textView: UITextView) {
        previewQuestionLabel.text = textView.text
    }
    
    //MARK: for Using Docomo API
    /* SOUND再生 */
    func playSound(text: String) {
        let ssml: AiTalkSsml = AiTalkSsml()
        let voice: AiTalkVoice = AiTalkVoice(voiceName: "nozomi")
        voice.addText(text)
        ssml.addVoice(voice)
        let search: AiTalkTextToSpeech = AiTalkTextToSpeech()
        let sendError = search.requestAiTalkSsmlToSound(ssml.makeSsml(), onComplete: { (data) in
            NSLog("onComplete")
            self.playAudio(data)
        }) { (receiveError) in
            self.onError(receiveError)
        }
        if (sendError != nil) {
            self.onError(sendError)
        }
        
    }
    
     func playAudio(data: NSData){
        NSLog("playAudio data.length=%d",Int(data.length))
        let convertData = AiTalkTextToSpeech.convertByteOrder16(data)
        AiTalkAudioPlayer.manager().playSound(self.addHeader(convertData))
    }

    func addHeader(data: NSData) -> NSData{
        var soundFileData: NSMutableData = NSMutableData()
        if data.length > 0 {
            let header: [UInt8] = self.setHeader(data.length)
            let headerData = NSData(bytes: header, length: 44)
            soundFileData = NSMutableData()
            soundFileData.appendData(headerData.subdataWithRange(NSMakeRange(0, 44)))
            soundFileData.appendData(data)
        }
        return soundFileData
    }
    
   func setHeader(dataLength: Int) -> [UInt8] {
        var header:[UInt8] = Array(count: 44, repeatedValue: 0)
        let longSampleRate: CLong = 16000
        let channels: Int = 1
        let byteRate = 16 * 11025 * channels / 8
        let totalDataLen = dataLength + 44
        
        
        
        header[0] = String("R").utf8.first!
        header[1] = String("I").utf8.first!
        header[2] = String("F").utf8.first!
        header[3] = String("F").utf8.first!
        header[4] = __uint8_t(totalDataLen & 0xff)
        header[5] = __uint8_t((totalDataLen >> 8) & 0xff)

        header[6] = __uint8_t((totalDataLen >> 16) & 0xff)
        header[7] = __uint8_t((totalDataLen >> 24) & 0xff)
        header[8] = String("W").utf8.first!
        header[9] = String("A").utf8.first!
        header[10] = String("V").utf8.first!
        header[11] = String("E").utf8.first!
        header[12] = String("f").utf8.first!
        header[13] = String("m").utf8.first!
        header[14] = String("t").utf8.first!
        header[15] = String(" ").utf8.first!
        header[16] = 16
        header[17] = 0
        header[18] = 0
        header[19] = 0
        header[20] = 1
        header[21] = 0
        header[22] = __uint8_t(channels)
        header[23] = 0
        header[24] = __uint8_t(longSampleRate & 0xff)
        header[25] = __uint8_t((longSampleRate >> 8) & 0xff)
        header[26] = __uint8_t((longSampleRate >> 16) & 0xff)
        header[27] = __uint8_t((longSampleRate >> 24) & 0xff)
        header[28] = __uint8_t(byteRate & 0xff)
        header[29] = __uint8_t((byteRate >> 8) & 0xff)
        header[30] = __uint8_t((byteRate >> 16) & 0xff)
        header[31] = __uint8_t((byteRate >> 24) & 0xff)
        header[32] = __uint8_t(2 * 8 / 8);
        header[33] = 0
        header[34] = 16
        header[35] = 0
        header[36] = String("d").utf8.first!
        header[37] = String("a").utf8.first!
        header[38] = String("t").utf8.first!
        header[39] = String("a").utf8.first!
        header[40] = __uint8_t(dataLength & 0xff)
        header[41] = __uint8_t((dataLength >> 8) & 0xff)
        header[42] = __uint8_t((dataLength >> 16) & 0xff)
        header[43] = __uint8_t((dataLength >> 24) & 0xff)
        ((dataLength >> 24) & 0xff);
        return header
    }
    
    func onError(error: NSError){
        NSLog("onError")
        let errorMessage: String = "ErrorCode:" + String(error.code) + "\nMessage:" + String(error.localizedDescription)
        let alert = UIAlertController(title: "ErrorCode", message: errorMessage, preferredStyle: .Alert)
        
        //アラートにボタンを追加
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil
            )
        )
        self.presentViewController(alert, animated: true, completion: nil)
    }
 
    
 
}

