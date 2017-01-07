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

extension ViewController {
    
    func trackpadInterfaceInit() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
        rightSwipe.direction = .right
        self.gestureInterface.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
        leftSwipe.direction = .left
        self.gestureInterface.addGestureRecognizer(leftSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upSwipe(_:)))
        upSwipe.direction = .up
        self.gestureInterface.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(downSwipe(_:)))
        downSwipe.direction = .down
        self.gestureInterface.addGestureRecognizer(downSwipe)
        
    }
    
    func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        print("RIGHT")
        selectedObject = selectedObject + 1
        gestureFunction()
    }
    
    func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        print("LEFT")
        selectedObject = selectedObject - 1
        gestureFunction()
    }
    
    func upSwipe(_ sender: UISwipeGestureRecognizer) {
        print("UP")
        selectedObject = selectedObject - 1
        gestureFunction()
        
    }
    
    func downSwipe(_ sender: UISwipeGestureRecognizer) {
        print("DOWN")
        selectedObject = selectedObject + 1
        gestureFunction()
    }
    
    func gestureFunction() {
        
        initGestureFunction()
        
        switch selectedObject {
        case 0:
            //タイトル
            previewTitleLabel.layer.borderColor = UIColor.gray.cgColor
            previewTitleLabel.layer.borderWidth = 3
            docomoSpeakModel.speak(previewTitleLabel.text!)
        case 1:
            //問題文入力ラベル
            previewQuestionLabel.layer.borderColor = UIColor.gray.cgColor
            previewQuestionLabel.layer.borderWidth = 3
            docomoSpeakModel.speak(previewQuestionLabel.text!)
        case 2:
            //選択肢1
            previewSelectButton[0].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak(previewSelectButton[0].currentTitle!)
        case 3:
            //選択肢2
            previewSelectButton[1].layer.borderColor = UIColor.gray.cgColor
            docomoSpeakModel.speak(previewSelectButton[1].currentTitle!)
        case 4:
            //選択肢3
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
        case 11:
            return
            
        default:
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
    }
    
    
}
