//
//  RealmExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import Foundation
import RealmSwift
import C4

extension ViewController {
    
    //保存処理
    func saveQuestion() {
        
        // 入力チェック
        if isValidateInputContents() == false{
            return
        }
        
        let question = Question()
        
        question.name = previewTitleLabel.text!
        question.question = previewQuestionLabel.text!
        
        question.answer1 = previewSelectButton[0].currentTitle!
        question.answer2 = previewSelectButton[1].currentTitle!
        question.answer3 = previewSelectButton[2].currentTitle!
        
        question.correctAnswer = correctAnswerWithNumber
        
        question.plistFileName = figureNumberString
        question.makingDate = NSDate()
        let screenshot = ScreenCaptureUtil.take(figureView)
        question.image = UIImagePNGRepresentation(screenshot)!
        
        // ToDoデータを永続化する処理
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(question)
            }
            //成功した時の処理
            NSLog("成功！")
            
        }catch{
            print("失敗")
        }
    }
    
    
    private func isValidateInputContents() -> Bool{
        // タイトルチェック
        if let name = previewTitleLabel.text{
            if name == "タイト" {
                return false
            }
        }else{
            return false
        }
        return true
    }

}
