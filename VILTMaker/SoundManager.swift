//
//  SoundManager.swift
//  c4-text
//
//  Created by Phil Owen on 5/26/16.
//  Copyright © 2016 Phil Owen. All rights reserved.
//

import Foundation

public class SoundManager {
    private let pongSound: YLAudioPlayer
    private let pipSounds: [YLSoundNote: YLAudioPlayer]
    
    func getAllSounds() -> [YLAudioPlayer] {
        return [pongSound] + pipSounds.values
    }
    
    init(_ plist: NSDictionary) {
        let sounds1 = plist["sounds"] as! NSDictionary
        func create(key: String) -> YLAudioPlayer {
            let name = "\(sounds1[key]!).caf"
            return YLAudioPlayer(name)
        }
        pongSound = create("pong")
        
        pipSounds = [
            .C4: create("c4"),
            .D4: create("d4"),
            .E4: create("e4"),
            .F4: create("f4"),
            .G4: create("g4"),
            .A4: create("a4"),
            .B4: create("b4"),
            .C5: create("c5"),
            .D5: create("d5"),
            .E5: create("e5")]
        
    }
    
    
    func pip(note: YLSoundNote) {
        let sound = pipSounds[note]!
        stopOtherSoundExcepting(sound)
        sound.play()
    }
    
    func pong() {
        stopOtherSoundExcepting(pongSound)
        pongSound.play()
    }
    
    func stopOtherSoundExcepting(player: YLAudioPlayer) {
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