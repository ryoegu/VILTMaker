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
import QuartzCore

extension ViewController {
    
    //保存処理
    func saveQuestion() {
        /*
         
         全部削除する処理
         do{
            let realm = try Realm()
            // Delete all objects from the realm
            try realm.write {
                realm.deleteAll()
            }
        }catch{
            
        }*/
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}
        })
        Realm.Configuration.defaultConfiguration = config
        
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
        question.makingDate = Date()
        let screenshot = take()
        question.image = UIImagePNGRepresentation(screenshot)!
        
        if uuid == "" {
            question.id = UUID().uuidString
            NSLog("UUID作成成功")
        }else{
            question.id = uuid
            NSLog("UUID必要なし")
        }
        // ToDoデータを永続化する処理
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(question, update: true)
            }
            //成功した時の処理
            NSLog("成功！")
            
        }catch let error as NSError{
            print(error)
        }
    }
    
    
    fileprivate func isValidateInputContents() -> Bool{
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
    
    func take()->UIImage{
        
        /*let imageView = UIView(frame: CGRectMake(0, 289, 768, 735))
        self.view.addSubview(imageView)
        
        let layer = imageView.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();*/
        
        /*let rect: CGRect = CGRectMake(0,289,768,735)*/
        
        
        
        
        // スクリーンショットの取得開始
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 1.0)
        
        // 描画
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        // 描画が行われたスクリーンショットの取得
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        
        // スクリーンショットの取得終了
        UIGraphicsEndImageContext()
        
        let cropRect  = CGRect(x: 0, y: 289, width: 768, height: 735)
        let cropRef   = screenShot?.cgImage?.cropping(to: cropRect)
        let cropImage = UIImage(cgImage: cropRef!)

        return cropImage
        
    }
}
