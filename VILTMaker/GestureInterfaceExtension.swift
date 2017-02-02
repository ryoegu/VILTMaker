//
//  GestureInterfaceExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/12/05.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//


import Foundation
import UIKit
import C4
import Spring

extension ViewController {
    
    func trackpadInterfaceInit() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.rightSwipe))
        rightSwipe.direction = .right
        self.gestureInterface.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.leftSwipe))
        leftSwipe.direction = .left
        self.gestureInterface.addGestureRecognizer(leftSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.upSwipe))
        upSwipe.direction = .up
        self.gestureInterface.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.downSwipe))
        downSwipe.direction = .down
        self.gestureInterface.addGestureRecognizer(downSwipe)
        
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(self.oneTapGesture))
        oneTap.numberOfTapsRequired = 1
        self.gestureInterface.addGestureRecognizer(oneTap)
        
    }
    
    func rightSwipe() {
        print("RIGHT")
        selectedObject = selectedObject + 1
        gestureCount = gestureCount + 1
        gestureFunction()
    }
    
    func leftSwipe() {
        print("LEFT")
        gestureCount = gestureCount + 1
        selectedObject = selectedObject - 1
        gestureFunction()
    }
    
    func upSwipe() {
        print("UP")
        gestureCount = gestureCount + 1
        selectedObject = selectedObject - 1
        gestureFunction()
        
    }
    
    func downSwipe() {
        print("DOWN")
        gestureCount = gestureCount + 1
        selectedObject = selectedObject + 1
        gestureFunction()
    }
    
    func oneTapGesture() {
        print("ONE TAP")
        self.tapGesture()
        
    }
    
    func gestureFunction() {
        
        initGestureFunction()
        
        
        switch selectedObject {
        case 0:
            //タイトル
            needToChangeObjectNumber = selectedObject
            previewTitleLabel.layer.borderColor = UIColor.gray.cgColor
            previewTitleLabel.layer.borderWidth = 3
            docomoSpeakModel.speak(previewTitleLabel.text!)
        case 1:
            //問題文入力ラベル
            needToChangeObjectNumber = selectedObject
            previewQuestionLabel.layer.borderColor = UIColor.gray.cgColor
            previewQuestionLabel.layer.borderWidth = 3
            docomoSpeakModel.speak(previewQuestionLabel.text!)
        case 2:
            //選択肢1
            needToChangeObjectNumber = selectedObject
            previewSelectButton[0].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak(previewSelectButton[0].currentTitle!)
        case 3:
            //選択肢2
            needToChangeObjectNumber = selectedObject
            previewSelectButton[1].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak(previewSelectButton[1].currentTitle!)
        case 4:
            //選択肢3
            needToChangeObjectNumber = selectedObject
            previewSelectButton[2].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak(previewSelectButton[2].currentTitle!)
        case 5:
            //図形
            oosiView.layer?.borderColor = UIColor.gray.cgColor
            oosiView.layer?.borderWidth = 3
            docomoSpeakModel.speak("図形エリア")
            return
        case 6:
            //Common Button 1
            commonButtons[0].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak("新規作成ボタン")
            return
        case 7:
            //Common Button 2
            commonButtons[1].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak("最初に戻るボタン")
            return
        case 8:
            //Common Button 3
            commonButtons[2].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak("音声スピード調整")
            return
        case 9:
            //Common Button 4
            commonButtons[3].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak("保存ボタン")
            return
        case 10:
            //Common Button 5
            commonButtons[4].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak("一覧ボタン")
            return
        /* Edit Mode Buttons */
        case 11:
            //編集モードマイクボタン
            editView.voiceInputButton.layer.borderWidth = 3
            docomoSpeakModel.speak("マイクボタン")
        case 12:
            //編集モードスピーカーボタン
            editView.voiceOutputButton.layer.borderWidth = 3
            docomoSpeakModel.speak("確認ボタン")
        case 13:
            //決定ボタン
            editView.editModeDoneButton.layer.borderWidth = 3
            docomoSpeakModel.speak("この内容で決定")
        case 14:
            //編集モード閉じるボタン
            editView.editModeExitButton.layer.borderWidth = 3
            docomoSpeakModel.speak("編集モードを閉じる")
        case 15:
            //形態素解析View用
            //ここにきたら自動的に100番台へ
            selectedObject = 100
            gestureFunction()
        case 99:
            selectedObject = 12
            gestureFunction()
        default:
            //100番台
            self.editView.selectCell(selectedObject-100)
            
        }
    }
    
    func initGestureFunction() {
        
        previewTitleLabel.layer.masksToBounds = true
        previewQuestionLabel.layer.masksToBounds = true
        oosiView.layer?.masksToBounds = true
        
        
        
        previewTitleLabel.layer.borderWidth = 0
        previewQuestionLabel.layer.borderWidth = 0
        previewSelectButton[0].layer.borderColor = UIColor.blue.cgColor
        previewSelectButton[1].layer.borderColor = UIColor.blue.cgColor
        previewSelectButton[2].layer.borderColor = UIColor.blue.cgColor
        oosiView.layer?.borderWidth = 0
        
        /* edit mode buttons */
        editView.voiceOutputButton.layer.borderWidth = 0
        editView.voiceInputButton.layer.borderWidth = 0
        editView.editModeDoneButton.layer.borderWidth = 0
        editView.editModeExitButton.layer.borderWidth = 0
        
        /* common buttons */
        commonButtons[0].layer.borderColor = UIColor.blue.cgColor
        commonButtons[1].layer.borderColor = UIColor.blue.cgColor
        commonButtons[2].layer.borderColor = UIColor.blue.cgColor
        commonButtons[3].layer.borderColor = UIColor.blue.cgColor
        commonButtons[4].layer.borderColor = UIColor.blue.cgColor
        
    }
    
    func tapGesture() {
        
        switch selectedObject {
        case 0:
            goToEditMode(0)
        case 1:
            goToEditMode(1)
        case 2:
            goToEditMode(2)
        case 3:
            goToEditMode(3)
        case 4:
            goToEditMode(4)
        case 5:
            //図形編集モード
            return
        case 6:
            return
        case 7:
            return
        case 8:
            goToSpeedChange()
            return
        case 9:
            saveQuestion()
            return
        case 19:
            return
        /* 編集モード */
        case 11:
            editView.voiceInputButtonPushed(editView.voiceInputButton)
        case 12:
            editView.voiceOutputButtonPushed(editView.voiceOutputButton as! BorderButton)
        case 13:
            editView.editModeDoneButtonPushed(editView.editModeDoneButton as! BorderButton)
        case 14:
            editView.editModeExitButtonPushed(editView.editModeExitButton as! BorderButton)
        default:
            return
        }
    }
    
    func goToSpeedChange() {
        speedChangeView.startAnimation()
    }
    
    func goToEditMode(_ number: Int) {
        editView.editModeAnimation()
        //TODO: 編集モードにはいったことを示す効果音
        
        var originalText = ""
        switch number {
        case 0:
            originalText = self.previewTitleLabel.text!
        case 1:
            originalText = self.previewQuestionLabel.text!
        case 2:
            originalText = (previewSelectButton[0].titleLabel?.text!)!
        case 3:
            originalText = (previewSelectButton[1].titleLabel?.text!)!
        case 4:
            originalText = (previewSelectButton[2].titleLabel?.text!)!
            
        default:
            break
        }
        analyzedStringArray = editView.getMorphologicalAnalysis(originalText)
        editView.tagsView.tags = analyzedStringArray
        afterChangingTextView.text = ""
        
        selectedObject = 11
        gestureFunction()
        
        
    }
    
    
}
