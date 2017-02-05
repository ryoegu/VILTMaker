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

class VoiceInputView: UIView {
    
    @IBOutlet var contentView: SpringView!
    
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
        if (audioRecorder?.isRecording)! {
            audioRecorder?.stop()
        }else{
            audioRecorder?.record()
        }
    }
    
    @IBAction func playButtonPushed() {
        
    }
    
    
    func setupAudioRecorder() {
        
        
        /// 録音可能カテゴリに設定する
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
        
        
        
        // 録音用URLを設定
        let dirURL = documentsDirectoryURL()
        print(dirURL)
        let fileName = "recording.caf"
        let recordingsURL = dirURL.appendingPathComponent(fileName)
        
        // 録音設定
        let recordSettings: [String: AnyObject] =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue as AnyObject,
             AVEncoderBitRateKey: 16 as AnyObject,
             AVNumberOfChannelsKey: 2 as AnyObject,
             AVSampleRateKey: 44100.0 as AnyObject]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingsURL!, settings: recordSettings)
        } catch {
            audioRecorder = nil
        }
        
    }
    
    /// DocumentsのURLを取得
    func documentsDirectoryURL() -> NSURL {
        let urls = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        if urls.isEmpty {
            
            fatalError("URLs for directory are empty.")
        }
        
        return urls[0] as NSURL
    }

    



}
