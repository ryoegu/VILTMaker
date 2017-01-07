//
//  MorphologicalAnalysisExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2017/01/08.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//
//  目的：形態素分析Extension
//

import UIKit
import Foundation
import UITags

extension ViewController {
    func getMorphologicalAnalysis(_ recognizedString: String) -> [String] {
        
        //参考URL http://dev.classmethod.jp/smartphone/iphone/ios10-morphological-analysis-from-speechrecognizer/
        // "en" = 英語
        // "ja" = 日本語
        
        var resultStringArray: [String] = []
        
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "ja"), options: 0)
        
        tagger.string = recognizedString
        
        // NSLinguisticTagSchemeTokenType
        // Word, Punctuation, Whitespace, Otherで判別が可能。今回はoptionsで.omitWhitespaceを設定して空白を無視するようにしています。
        tagger.enumerateTags(in: NSRange(location: 0, length: recognizedString.characters.count), scheme: NSLinguisticTagSchemeTokenType, options: [.omitWhitespace]) { tag, tokenRange, sentenceRange, stop in
            
            let subString = (recognizedString as NSString).substring(with: tokenRange)
            print("\(subString) : \(tag)")
            resultStringArray.append(subString)
 
        }
        return resultStringArray
        
//        self.tagsView.tags = self.analyzedStringArray
    }
    
    func joinedAllAnalyzedString(_ strArray: [String]) -> String {
        let allJoinedString = strArray.joined()
        return allJoinedString
    }
    
    // MARK: 大文字など、文字変換
    func changeCharacter(_ string: String) -> String {
        var bigString = string.uppercased()
        bigString = bigString.replacingOccurrences(of: " ", with: "")
        bigString = bigString.replacingOccurrences(of: "合同", with: "≡")
        return bigString
    }

}

extension ViewController: UITagsViewDelegate{
    
    func tagSelected(atIndex index: Int) {
        print("Tag at index:\(index) selected")
        selectedWordInTagsView = index
        docomoSpeakModel.speak(self.analyzedStringArray[index])
        
        UIView.animate(withDuration: TimeInterval(CGFloat(0.8)), animations: {
            self.wordEditView.isHidden = false
        })

        
        
    }
    func tagDeselected(atIndex index:Int) -> Void {
        print("Tag at index:\(index) deselected")
        selectedWordInTagsView = -1 //初期値は-1
        UIView.animate(withDuration: TimeInterval(CGFloat(0.8)), animations: {
            self.wordEditView.isHidden = true
        })
    }

    
}
