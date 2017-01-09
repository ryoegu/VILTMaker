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
        gestureFunction()
    }
    
    func leftSwipe() {
        print("LEFT")
        selectedObject = selectedObject - 1
        gestureFunction()
    }
    
    func upSwipe() {
        print("UP")
        selectedObject = selectedObject - 1
        gestureFunction()
        
    }
    
    func downSwipe() {
        print("DOWN")
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
            return
        case 7:
            //Common Button 2
            return
        case 8:
            //Common Button 3
            return
        case 9:
            //Common Button 4
            return
        case 10:
            //Common Button 5
            return
        /* Edit Mode Buttons */
        case 11:
            //編集モードマイクボタン
            voiceInputButton.layer.borderWidth = 3
            docomoSpeakModel.speak("マイクボタン")
        case 12:
            //編集モードスピーカーボタン
            voiceOutputButton.layer.borderWidth = 3
            docomoSpeakModel.speak("確認ボタン")
        case 13:
            //決定ボタン
            editModeDoneButton.layer.borderWidth = 3
            docomoSpeakModel.speak("この内容で決定")
        case 14:
            //編集モード閉じるボタン
            editModeExitButton.layer.borderWidth = 3
            docomoSpeakModel.speak("編集モードを閉じる")
        case 15:
            //形態素解析View用にあけておく
            //ここにきたら自動的に100番台へ
            return
        default:
            //100番台
            return
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
        voiceOutputButton.layer.borderWidth = 0
        voiceInputButton.layer.borderWidth = 0
        editModeDoneButton.layer.borderWidth = 0
        editModeExitButton.layer.borderWidth = 0
        
    }
    
    func tapGesture() {
        
        switch selectedObject {
        case 0:
            goToEditMode()
        case 1:
            goToEditMode()
        case 2:
            goToEditMode()
        case 3:
            goToEditMode()
        case 4:
            goToEditMode()
        case 5:
            //図形編集モード
            return
        case 6:
            return
        case 7:
            return
        case 8:
            return
        case 9:
            return
        case 19:
            return
        /* 編集モード */
        case 11:
            voiceInputButtonPushed(voiceInputButton)
        case 12:
            voiceOutputButtonPushed(voiceOutputButton as! BorderButton)
        case 13:
            editModeDoneButtonPushed(editModeDoneButton as! BorderButton)
        case 14:
            editModeExitButtonPushed(editModeExitButton as! BorderButton)
        default:
            return
        }
    }
    
    func goToEditMode() {
        editModeAnimation()
        //TODO: 編集モードにはいったことを示す効果音
        selectedObject = 11
        gestureFunction()
        
        
    }
    
    
}
