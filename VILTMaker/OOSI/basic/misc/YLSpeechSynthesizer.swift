//
//  YLSpeechSynthesizer.swift
//  Textbook
//
//  Created by Hiloki OE on 9/24/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation
import AVFoundation

open class YLSpeechSynthesizer: NSObject {
    let speaker: AVSpeechSynthesizer

    public override init() {
        speaker = AVSpeechSynthesizer()
    }
    
    open func speak(_ s: String) {
        if speaker.isSpeaking {
            speaker.stopSpeaking(at: .immediate)
        }
        let ut = AVSpeechUtterance(string: s)
        ut.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        ut.rate = 0.6
        speaker.speak(ut)
    }
}
