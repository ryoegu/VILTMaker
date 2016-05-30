//
//  ViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var previewQuestionLabel: UILabel!
    @IBOutlet var editQuestionTextView: UITextView!
    @IBOutlet var previewSelectButton: [BorderButton]!
    
    let docomoSpeakModel: SpeakModel = SpeakModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        editQuestionTextView.delegate = self
        //初期値（仮置き）
        previewSelectButton[1].backgroundColor = ConstColor.pink
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectButtonPushed(sender: BorderButton) {
        //1回タップで音声合成。
        var buttonTitle = sender.currentTitle
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("△", withString: "三角形")
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("≡", withString: " 合同 ")
        NSLog("buttonTitle==%@",buttonTitle!)
        
        docomoSpeakModel.speak(buttonTitle!)
        
    }
    //MARK: ダブルタップ処理
    @IBAction func editButton1DoubleTapped(sender: UITapGestureRecognizer) {
        NSLog("Edit Button 1 Double Tapped")
        self.doubleTappedGeneralWithButtonIndex(0)
    }
    @IBAction func editButton2DoubleTapped(sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(1)
    }
    @IBAction func editButton3DoubleTapped(sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(2)
    }
    
    func doubleTappedGeneralWithButtonIndex(index:Int){
        for j in 0...2 {
            previewSelectButton[j].backgroundColor = ConstColor.white
        }
        previewSelectButton[index].backgroundColor = ConstColor.pink
    }
    
    //MARK: TextView処理
    func textViewDidChange(textView: UITextView) {
        previewQuestionLabel.text = textView.text
    }
    
    //MARK: Google Speech API
    
    
    
 
}

