//
//  Question.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import Foundation
import RealmSwift

class Question: Object{
    
    dynamic var id: String = ""
    /// 名前
    dynamic var name = ""
    /// 問題文
    dynamic var question = ""
    /// 選択肢1,2,3
    dynamic var answer1 = ""
    dynamic var answer2 = ""
    dynamic var answer3 = ""
    
    ///正しい答え
    dynamic var correctAnswer = 0
    
    
    /// OOSI配列
    dynamic var oosiDictionaryData = Data()
    
    //作成日時
    dynamic var makingDate = Date(timeIntervalSince1970: 0)
    
    //スクショ
    dynamic var image = Data()
    
    
    //実験用
    dynamic var gestureCount: Int = 0
    dynamic var drawTime: Float = 0.0
    dynamic var editTime: Float = 0.0
    dynamic var person: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
