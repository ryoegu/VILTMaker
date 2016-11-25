//
//  ViewControllerAudioExtention.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/18.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension ViewController: AVAudioPlayerDelegate {
    
    //MARK: Set Audio Player(効果音)
    func initAudioPlayers() {
        
        //Change Answer
        do {
            let filePath = Bundle.main.path(forResource: "changeAnswer", ofType: "mp3")
            let audioPath = URL(fileURLWithPath: filePath!)
            changeAnswerAudioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            changeAnswerAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //Single Cursor
        do {
            let filePath = Bundle.main.path(forResource: "cursorSingle", ofType: "mp3")
            let audioPath = URL(fileURLWithPath: filePath!)
            singleCursorAudioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            singleCursorAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //Double Cursor
        do {
            let filePath = Bundle.main.path(forResource: "cursorDouble", ofType: "mp3")
            let audioPath = URL(fileURLWithPath: filePath!)
            doubleCursorAudioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            doubleCursorAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //OK Button
        do {
            let filePath = Bundle.main.path(forResource: "okButton", ofType: "mp3")
            let audioPath = URL(fileURLWithPath: filePath!)
            okAudioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            okAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //Record Start Button
        do {
            let filePath = Bundle.main.path(forResource: "recordStart", ofType: "mp3")
            let audioPath = URL(fileURLWithPath: filePath!)
            recordStartAudioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            recordStartAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
    }
    
}
