//
//  EditModeExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2017/01/08.
//  Copyright © 2017年 Ryo Eguchi. All rights reserved.
//
//  目的：編集モード
//

import UIKit
import Foundation
import Spring

extension ViewController {

    /* 
     【Edit Mode(編集モード)に関する処理】
     
     Edit Modeに関しては、処理が多くなるのでこちらに分離して処理することとする。
     編集モードは、3つのボタンと1つのView、内包されている単語編集モードがあり、それぞれ、
     ・[11]マイクボタン（音声入力ボタン） voiceInputButton
     ・[12]スピーカーボタン（音声出力ボタン）voiceOutputButton
     ・[13]DONEボタン（決定ボタン）doneButton
     ・[14]✗ボタン（編集モードを閉じるボタン） editModeExitButton
     ・[100番代〜]tagsView（単語音節ごとに区切られているもの）
     とする。
     
     editModeを起動するときはかならずアニメーションをつけ、「編集モード+音声入力ボタン」と発音。
     
     
     【Word Edit Viewについて】
     使用する際は、かならず「wordEditViewInit()を実行」
     ボタン2つとラベル1つから構成されている。
     
     ・[16]マイクボタン（音声入力ボタン）wordEditVoiceInputButton
     ・[17]DONE&削除ボタン wordEditDoneButton
     */
    
    
    //MARK: Edit Mode
    
    func editModeAnimation() {
        if self.editView.isHidden {
            //もともと表示されていなかった場合
            self.editView.isHidden = false
            self.editView.animation = "fadeInUp"
            self.editView.curve = "easeInOut"
            self.editView.duration = 1.5
            
        }else{
            //もともと表示されていた場合
            self.editView.animation = "swing"
            self.editView.curve = "linear"
            self.editView.duration = 1.0
            
        }
        self.editView.animate()
        
    }
    

    
    @IBAction func voiceInputButtonPushed(_ sender: UIButton) {
        recordStartAudioPlayer.play()
        
        if audioEngine.isRunning {
            NSLog("音声入力終了")
            self.stopRecord()
            self.analyzedStringArray = self.getMorphologicalAnalysis(self.afterChangingTextView.text)
            self.tagsView.tags = self.analyzedStringArray
            docomoSpeakModel.speak(self.afterChangingTextView.text)
            
        }else{
            NSLog("音声入力開始")
            self.startRecord()
            
        }
    }
    
    @IBAction func voiceOutputButtonPushed(_ sender: BorderButton) {
        docomoSpeakModel.speak(self.joinedAllAnalyzedString(self.analyzedStringArray))
    }
    
    @IBAction func editModeDoneButtonPushed(_ sender: BorderButton) {
        
    }
    
    @IBAction func editModeExitButtonPushed(_ sender: BorderButton) {
        
    }
    
    //MARK: Word Edit Mode
    
    func wordEditViewInit() {
        self.wordEditLabel.isHidden = true
        self.wordEditLabel.text = ""
        self.wordEditVoiceInputButton.frame = CGRect(x: 155, y: 8, width: 210, height:47)
        self.wordEditDoneButton.frame = CGRect(x: 373, y: 8, width: 210, height: 47)
        self.wordEditDoneButton.backgroundColor = UIColor.red
        self.wordEditDoneButton.setTitle("", for: UIControlState.normal)
    }
    
    @IBAction func wordEditVoiceInputButtonTapped(_ sender: BorderButton) {
        
        recordStartAudioPlayer.play()
        if audioEngine.isRunning {
            NSLog("音声入力終了")
            self.stopRecord()
            
            UIView.animate(withDuration: TimeInterval(CGFloat(0.5)), animations: {
                
                self.wordEditVoiceInputButton.frame = CGRect(x: 432, y: 8, width: 60, height: 47)
                self.wordEditDoneButton.frame = CGRect(x: 507, y: 8, width: 77, height: 47)
                
                
            })
            
            self.wordEditLabel.text = joinedAllAnalyzedString(self.getMorphologicalAnalysis(self.afterChangingTextView.text))
            if self.afterChangingTextView.text == "" {
                self.wordEditLabel.text = "認識されませんでした"
            }
            docomoSpeakModel.speak(self.wordEditLabel.text!)
        }else{
            self.afterChangingTextView.text = ""
            NSLog("音声入力開始")
            self.startRecord()
            UIView.animate(withDuration: TimeInterval(CGFloat(0.8)), animations: {
                self.wordEditLabel.isHidden = false
                self.wordEditVoiceInputButton.frame = CGRect(x: 432, y: 8, width: 140, height: 47)
                self.wordEditDoneButton.frame = CGRect(x: 584, y: 8, width: 0, height: 47)
                self.wordEditDoneButton.backgroundColor = UIColor.blue
                self.wordEditDoneButton.setTitle("DONE", for: UIControlState.normal)
                
            })
            
            
        }
    }

    @IBAction func wordEditDoneButtonTapped(_ sender: BorderButton) {
        
        if self.wordEditLabel.text == "" {
            self.analyzedStringArray.remove(at: self.selectedWordInTagsView)
        }else if self.wordEditLabel.text == "認識されませんでした"{
            
        }else{
            self.analyzedStringArray[self.selectedWordInTagsView] = self.wordEditLabel.text!
        }
        self.wordEditViewInit()
        self.selectedWordInTagsView = -1
        self.wordEditView.isHidden = true
        self.tagsView.tags = self.analyzedStringArray
        
    }
    
    
}
