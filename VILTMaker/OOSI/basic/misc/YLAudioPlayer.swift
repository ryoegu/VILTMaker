//
//  YLAudioPlayer.swift
//  Textbook
//
//  Created by Hiloki OE on 9/23/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation
import C4

open class YLAudioPlayer: NSObject {
    let player: AudioPlayer
    
    public init(_ name: String) {
        player = AudioPlayer(name)!
        player.volume = 1
        super.init()
    }
    
    open var volume: Double {
        get {
            return player.volume
        }
        set {
            player.volume = newValue
        }
    }
    
    open func play() {
        let remain = player.duration - player.currentTime
        if !player.playing {
            player.play()
            print("Start play")
        } else if remain < 0.8 {
            stop()
            player.play()
            print("Previous play is finishing. Start next play")
        }
    }
    
    open func stop() {
        player.stop()
        player.currentTime = 0
    }
    
    open override var description: String {
        return player.description
    }
}
