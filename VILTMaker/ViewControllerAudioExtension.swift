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
            let filePath = NSBundle.mainBundle().pathForResource("changeAnswer", ofType: "mp3")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            changeAnswerAudioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
            changeAnswerAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //Single Cursor
        do {
            let filePath = NSBundle.mainBundle().pathForResource("cursorSingle", ofType: "mp3")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            singleCursorAudioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
            singleCursorAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //Double Cursor
        do {
            let filePath = NSBundle.mainBundle().pathForResource("cursorDouble", ofType: "mp3")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            doubleCursorAudioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
            doubleCursorAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //OK Button
        do {
            let filePath = NSBundle.mainBundle().pathForResource("okButton", ofType: "mp3")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            okAudioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
            okAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
        //Record Start Button
        do {
            let filePath = NSBundle.mainBundle().pathForResource("recordStart", ofType: "mp3")
            let audioPath = NSURL(fileURLWithPath: filePath!)
            recordStartAudioPlayer = try AVAudioPlayer(contentsOfURL: audioPath)
            recordStartAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
        
    }
    
}
