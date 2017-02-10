//
//  VoiceInputView.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2017/02/05.
//  Copyright © 2017年 Ryo Eguchi. All rights reserved.
//

import UIKit
import Spring
import AVFoundation

class VoiceInputView: UIView, AVAudioRecorderDelegate {
    
    @IBOutlet var contentView: SpringView!
    
    @IBOutlet var recordButton: BorderButton!
    
    var isVoiceRecording: Bool = false
    
    var audioRecorder: AVAudioRecorder?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func loadXib() {
        Bundle.main.loadNibNamed("VoiceInputView", owner: self, options: nil)
        self.contentView.frame = CGRect(x: 0, y: 0, width: 576, height: 150)
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor(hex: "6F1DFF").cgColor
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.cornerRadius = 4.0
        
        
        self.addSubview(contentView)
        
        self.contentView.isHidden = true
        
        // 録音可能カテゴリに設定する
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch  {
            // エラー処理
            fatalError("カテゴリ設定失敗")
        }
        
        // sessionのアクティブ化
        do {
            try session.setActive(true)
        } catch {
            // audio session有効化失敗時の処理
            // (ここではエラーとして停止している）
            fatalError("session有効化失敗")
        }
    }
    
    func startAnimation() {
        self.contentView.isHidden = false
        self.contentView.animation = "fadeInUp"
        self.contentView.curve = "easeInOut"
        self.contentView.duration = 1.5
        self.contentView.animate()
    }
    
    @IBAction func closeButtonPushed(_ sender: BorderButton) {
        closeView()
    }
    
    func closeView() {
        self.contentView.animation = "fadeOut"
        self.contentView.curve = "easeInOut"
        self.contentView.duration = 1.5
        self.contentView.animate()
    }
    
    @IBAction func recordButtonPushed() {
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            let fileName = tmp.circleVoiceName
            setupAudioRecorder(fileName: fileName)
        }
        
        if (audioRecorder?.isRecording)! {
            audioRecorder?.stop()
            print("RECORD STOPPED")
            self.recordButton.setTitle("●", for: .normal)
            isVoiceRecording = false
        }else{
            print("RECORD START")
            audioRecorder?.record()
            print("AUDIO RECORDING BOOL == \(audioRecorder?.isRecording)")
//            audioRecorder?.isMeteringEnabled = true
            self.recordButton.setTitle("■", for: .normal)
            isVoiceRecording = true
        
        }
    }
    
    @IBAction func playButtonPushed() {
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            let fileName = tmp.circleVoiceName
            tmp.playSound(fileName)
        }
    }


    //fileNameは●●.cafで入力
    func setupAudioRecorder(fileName: String) {
        // 録音用URLを設定
        let dirURL = documentsDirectoryURL()
        let recordingsURL = dirURL.appendingPathComponent(fileName)
        print(dirURL)
        // 録音設定
        let recordSettings: [String: AnyObject] =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue as AnyObject,
             AVEncoderBitRateKey: 16 as AnyObject,
             AVNumberOfChannelsKey: 1 as AnyObject,
             AVSampleRateKey: 44100.0 as AnyObject]

        
        if audioRecorder == nil {
            
            do {
                audioRecorder = try AVAudioRecorder(url: recordingsURL!, settings: recordSettings)
                audioRecorder?.delegate = self
                
            } catch {
                audioRecorder = nil
            }
            
            
        }else{
            
            
            if !isVoiceRecording {
                do {
                    audioRecorder = try AVAudioRecorder(url: recordingsURL!, settings: recordSettings)
                } catch {
                    audioRecorder = nil
                }
            }
            
        }
        
    }
    
    /// DocumentsのURLを取得
    func documentsDirectoryURL() -> NSURL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0] as NSURL
    }
    

}
