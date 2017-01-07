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

extension ViewController {
    func getMorphologicalAnalysis(_ recognizedString: String) {
        
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
        print("MA_RESULT===\(resultStringArray)")
        
    }
    
    

}
