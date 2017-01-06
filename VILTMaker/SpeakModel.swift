//
//  SpeakModel.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/29.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import Foundation
import AVFoundation

class SpeakModel: NSObject {
    
    override init() {
        // DoCoMo開発者ポータルから取得したAPIキーの設定
        if let docomoAPIKEY = KeyManager().getValue("docomoAPIKey") as? String {
            AuthApiKey.initializeAuth(docomoAPIKEY)
        }
    }
    
    func speak(_ text: String) {
        NSLog("音声発信中[%@]",text)
        let ssml: AiTalkSsml = AiTalkSsml()
        let voice: AiTalkVoice = AiTalkVoice(voiceName: "nozomi")
        voice.addText(text)
        ssml.add(voice)
        let search: AiTalkTextToSpeech = AiTalkTextToSpeech()
        let sendError = search.requestAiTalkSsml(toSound: ssml.make(), onComplete: { (data) in
            NSLog("onComplete")
            self.playAudio(data!)
        }) { (receiveError) in
            self.onError(receiveError!)
        }
        if (sendError != nil) {
            self.onError(sendError!)
        }
        
    }
    
    func playAudio(_ data: Data){
        NSLog("playAudio data.length=%d",Int(data.count))
        let convertData = AiTalkTextToSpeech.convertByteOrder16(data)
        AiTalkAudioPlayer.manager().playSound(self.addHeader(convertData!))
    }
    
    func addHeader(_ data: Data) -> Data{
        var soundFileData: NSMutableData = NSMutableData()
        if data.count > 0 {
            let header: [UInt8] = self.setHeader(data.count)
            let headerData = Data(bytes: UnsafePointer<UInt8>(header), count: 44)
            soundFileData = NSMutableData()
            soundFileData.append(headerData.subdata(in: 0..<44))
            soundFileData.append(data)
        }
        return soundFileData as Data
    }
    
    func setHeader(_ dataLength: Int) -> [UInt8] {
        var header:[UInt8] = Array(repeating: 0, count: 44)
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
    
    func onError(_ error: NSError){
        NSLog("onError")
        let errorMessage: String = "ErrorCode:" + String(error.code) + "\nMessage:" + String(error.localizedDescription)
        let alert = UIAlertController(title: "ErrorCode", message: errorMessage, preferredStyle: .alert)
        
        //アラートにボタンを追加
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.default,
                handler: nil
            )
        )
        //self.presentViewController(alert, animated: true, completion: nil)
    }

    
}
