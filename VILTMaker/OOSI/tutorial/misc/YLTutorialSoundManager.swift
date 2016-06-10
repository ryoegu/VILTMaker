//
//  YLSoundController.swift
//  Textbook
//
//  Created by Hiloki OE on 9/24/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation

public class YLTutorialSoundManager {
    private let correctSound: YLAudioPlayer
    private let wrongSound: YLAudioPlayer
    
    private let pongSound: YLAudioPlayer
    private let pipSounds: [YLSoundNote: YLAudioPlayer]

    private let pieVoice: YLAudioPlayer
    
    private let questionDescriptionVoice:  YLAudioPlayer!
    private let choiceDescriptionVoices: [YLAudioPlayer]

    private let sounds: [YLAudioPlayer]
    
    
    init(plist: NSDictionary) {
        let sounds1 = plist["sounds"] as! NSDictionary
        func create(key: String) -> YLAudioPlayer {
            let name = "\(sounds1[key]!).caf"
            return YLAudioPlayer(name)
        }
        correctSound = create("correct")
        wrongSound = create("wrong")
        
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
        
        pieVoice = create("piename")
        
        questionDescriptionVoice = create("question1")
        
        choiceDescriptionVoices = [
            create("question1_1"),
            create("question1_2"),
            create("question1_3")]
        
        sounds = [ correctSound, wrongSound, pongSound, pieVoice, questionDescriptionVoice ]
                + pipSounds.values
                + choiceDescriptionVoices
    }

    func correct() {
        stopOtherSoundExcepting(correctSound)
        correctSound.play()
    }
    
    func wrong() {
        wrongSound.play()
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
    
    func sayYouAreOnPie() {
        stopOtherSoundExcepting(pieVoice)
        pieVoice.play()
    }
    
    func sayQuestionDescription() {
        let sound = questionDescriptionVoice
        stopOtherSoundExcepting(sound)
        sound.play()
    }
    
    func sayChoiceDescription(index: Int) {
        let sound = choiceDescriptionVoices[index]
        stopOtherSoundExcepting(sound)
        sound.play()
    }
    
    func stopOtherSoundExcepting(player: YLAudioPlayer) {
        for player1 in sounds {
            if player != player1 {
                player1.stop()
            }
        }
    }
    
    func stopAllSounds() {
        for player in sounds {
            player.stop()
        }
    }}