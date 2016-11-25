//
//  SoundManager.swift
//  c4-text
//
//  Created by Phil Owen on 5/26/16.
//  Copyright © 2016 Phil Owen. All rights reserved.
//

import Foundation

open class SoundManager {
    fileprivate let pongSound: YLAudioPlayer
    fileprivate let pipSounds: [YLSoundNote: YLAudioPlayer]
    
    func getAllSounds() -> [YLAudioPlayer] {
        return [pongSound] + pipSounds.values
    }
    
    init(_ plist: NSDictionary) {
        let sounds1 = plist["sounds"] as! NSDictionary
        func create(_ key: String) -> YLAudioPlayer {
            let name = "\(sounds1[key]!).caf"
            return YLAudioPlayer(name)
        }
        pongSound = create("pong")
        
        pipSounds = [
            .c4: create("c4"),
            .d4: create("d4"),
            .e4: create("e4"),
            .f4: create("f4"),
            .g4: create("g4"),
            .a4: create("a4"),
            .b4: create("b4"),
            .c5: create("c5"),
            .d5: create("d5"),
            .e5: create("e5")]
        
    }
    
    
    func pip(_ note: YLSoundNote) {
        let sound = pipSounds[note]!
        stopOtherSoundExcepting(sound)
        sound.play()
    }
    
    func pong() {
        stopOtherSoundExcepting(pongSound)
        pongSound.play()
    }
    
    func stopOtherSoundExcepting(_ player: YLAudioPlayer) {
        for player1 in getAllSounds() {
            if player != player1 {
                player1.stop()
            }
        }
    }
    
    func stopAllSounds() {
        for player in getAllSounds() {
            player.stop()
        }
    }}
