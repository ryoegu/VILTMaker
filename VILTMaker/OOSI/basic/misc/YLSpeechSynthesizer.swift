//
//  YLSpeechSynthesizer.swift
//  Textbook
//
//  Created by Hiloki OE on 9/24/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation
import AVFoundation

public class YLSpeechSynthesizer: NSObject {
    let speaker: AVSpeechSynthesizer

    public override init() {
        speaker = AVSpeechSynthesizer()
    }
    
    public func speak(s: String) {
        if speaker.speaking {
            speaker.stopSpeakingAtBoundary(.Immediate)
        }
        let ut = AVSpeechUtterance(string: s)
        ut.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        ut.rate = 0.6
        speaker.speakUtterance(ut)
    }
}