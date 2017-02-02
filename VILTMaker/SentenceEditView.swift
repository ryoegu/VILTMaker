//
//  SentenceEditView.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2017/01/14.
//  Copyright © 2017年 Ryo Eguchi. All rights reserved.
//

import UIKit
import Spring
import UITags

class SentenceEditView: UIView {
    
    @IBOutlet var contentView: SpringView!
    
    @IBOutlet var voiceInputButton: UIButton!
    @IBOutlet var voiceOutputButton: UIButton!
    @IBOutlet var editModeDoneButton: UIButton!
    @IBOutlet var editModeExitButton: UIButton!
    @IBOutlet var tagsView: UITags!
    
    /* Word Edit View Objects */
    @IBOutlet var wordEditGuideLabel: UILabel!
    @IBOutlet var wordEditView: UIView!
    @IBOutlet var wordEditLabel: UILabel!
    @IBOutlet var wordEditVoiceInputButton: BorderButton!
    @IBOutlet var wordEditDoneButton: BorderButton!

    @IBOutlet var titleLabel: UILabel!
    
    var selectedWordInTagsView: Int = -1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        wordEditViewInit()
        tagsViewInit()
        
        self.wordEditGuideLabel.layer.masksToBounds = true
        self.wordEditGuideLabel.layer.borderWidth = 2.0
        self.wordEditGuideLabel.layer.borderColor = UIColor.black.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadXib() {
        Bundle.main.loadNibNamed("SentenceEditView", owner: self, options: nil)
        self.contentView.frame = CGRect(x: 0, y: 0, width: 576, height: 400)
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor(hex: "6F1DFF").cgColor
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.cornerRadius = 4.0
        
        
        self.addSubview(contentView)
        
        self.contentView.isHidden = true
        self.wordEditView.isHidden = true
   
    }
    
    func labelSet(_ needToChangeObjectNumber: Int) -> String {
        switch needToChangeObjectNumber {
        case 0:
            return "タイトル編集"
        case 1:
            return "問題文編集"
        case 2:
            return "選択肢1編集"
        case 3:
            return "選択肢2編集"
        case 4:
            return "選択肢3編集"
        default:
            return "文章編集"
        }
    }
    
    func wordEditViewInit() {
        
        
        self.wordEditLabel.isHidden = true
        self.wordEditLabel.text = ""
        self.wordEditVoiceInputButton.frame = CGRect(x: 140, y: 8, width: 210, height:47)
        self.wordEditDoneButton.frame = CGRect(x: 358, y: 8, width: 210, height: 47)
        self.wordEditDoneButton.backgroundColor = UIColor.red
        self.wordEditDoneButton.setTitle("", for: UIControlState.normal)
        
        
    }
    
    fileprivate func tagsViewInit() {
        self.tagsView.delegate = self
    }
    
    func editModeAnimation() {
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            
            titleLabel.text = labelSet(tmp.needToChangeObjectNumber)
            
            
            
            if tmp.selectedObject >= 0 && tmp.selectedObject <= 4 {
                //もともと表示されていなかった場合
                self.contentView.isHidden = false
                self.contentView.animation = "fadeInUp"
                self.contentView.curve = "easeInOut"
                self.contentView.duration = 1.5
                
            }else{
                //もともと表示されていた場合
                self.contentView.animation = "swing"
                self.contentView.curve = "linear"
                self.contentView.duration = 1.0
                
            }
            self.contentView.animate()
        
        }
        
        
    }

    
    @IBAction func voiceInputButtonPushed(_ sender: UIButton) {
        
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            tmp.recordStartAudioPlayer.play()
            
            if tmp.audioEngine.isRunning {
                NSLog("音声入力終了")
                tmp.stopRecord()
                tmp.analyzedStringArray = self.getMorphologicalAnalysis(tmp.afterChangingTextView.text)
                self.tagsView.tags = tmp.analyzedStringArray
                tmp.docomoSpeakModel.speak(tmp.afterChangingTextView.text)
                
            }else{
                NSLog("音声入力開始")
                tmp.startRecord()
                
            }
            
        }
        
    }
    
    @IBAction func voiceOutputButtonPushed(_ sender: BorderButton) {
        
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            tmp.docomoSpeakModel.speak(self.joinedAllAnalyzedString(tmp.analyzedStringArray))
        }
    }
    
    @IBAction func editModeDoneButtonPushed(_ sender: BorderButton) {
        saveToPreview()
        closeEditMode()
    }
    
    func saveToPreview() {
        
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            if tmp.analyzedStringArray != nil {
                let afterString = joinedAllAnalyzedString(tmp.analyzedStringArray)
                switch tmp.needToChangeObjectNumber {
                case 1:
                    tmp.previewQuestionLabel.text = afterString
                    break
                case 0:
                    tmp.previewTitleLabel.text = afterString
                    break
                default:
                    tmp.previewSelectButton[tmp.needToChangeObjectNumber-2].setTitle(afterString, for: UIControlState())
                    break
                }
            }
            
            
        }
        
    }
    
    @IBAction func setCorrectAnswer(_ sender: BorderButton) {
        
    }
    
    @IBAction func editModeExitButtonPushed(_ sender: BorderButton) {
        closeEditMode()
    }
    
    func closeEditMode() {
        self.contentView.animation = "fadeOut"
        self.contentView.curve = "easeInOut"
        self.contentView.duration = 1.5
        self.contentView.animate()
        
        
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            tmp.selectedObject = tmp.needToChangeObjectNumber
            self.tagsView.tags = []
            tmp.gestureFunction()
        }
        
    }
    
    //MARK: Word Edit Mode
   
    @IBAction func wordEditVoiceInputButtonTapped(_ sender: BorderButton) {
        
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            tmp.recordStartAudioPlayer.play()
            if tmp.audioEngine.isRunning {
                NSLog("音声入力終了")
                tmp.stopRecord()
                
                UIView.animate(withDuration: TimeInterval(CGFloat(0.5)), animations: {
                    
                    self.wordEditVoiceInputButton.frame = CGRect(x: 417, y: 8, width: 60, height: 47)
                    self.wordEditDoneButton.frame = CGRect(x: 492, y: 8, width: 77, height: 47)
                })
                
                self.wordEditLabel.text = joinedAllAnalyzedString(self.getMorphologicalAnalysis(tmp.afterChangingTextView.text))
                if tmp.afterChangingTextView.text == "" {
                    self.wordEditLabel.text = "認識されませんでした"
                }
                tmp.docomoSpeakModel.speak(self.wordEditLabel.text!)
            }else{
                tmp.afterChangingTextView.text = ""
                NSLog("音声入力開始")
                tmp.startRecord()
                UIView.animate(withDuration: TimeInterval(CGFloat(0.8)), animations: {
                    self.wordEditLabel.isHidden = false
                    self.wordEditVoiceInputButton.frame = CGRect(x: 432, y: 8, width: 140, height: 47)
                    self.wordEditDoneButton.frame = CGRect(x: 584, y: 8, width: 0, height: 47)
                    self.wordEditDoneButton.backgroundColor = UIColor.red
                    self.wordEditDoneButton.setTitle("DONE", for: UIControlState.normal)
                    
                })
                
            }

        }
        
        
    }
    
    @IBAction func wordEditDoneButtonTapped(_ sender: BorderButton) {
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            if self.wordEditLabel.text == "" {
                tmp.analyzedStringArray.remove(at: self.selectedWordInTagsView)
            }else if self.wordEditLabel.text == "認識されませんでした"{
                
            }else{
                tmp.analyzedStringArray[self.selectedWordInTagsView] = self.wordEditLabel.text!
            }
            self.wordEditViewInit()
            self.selectedWordInTagsView = -1
            self.wordEditView.isHidden = true
            self.tagsView.tags = tmp.analyzedStringArray
            
        }
        
    }
    
    func selectCell(_ row: Int) {
        //self.tagsView.collectionView?.delegate = self
        let indexPath: IndexPath = IndexPath(row: row, section: 0)
        //self.tagsView.collectionView(self.tagsView, didSelectItemAt: indexPath)
        
        if let tmp = UIApplication.shared.forwardViewController as? ViewController {
            
            if tmp.analyzedStringArray.count-1 < row {
                tmp.selectedObject = 100
                tmp.gestureFunction()
            }else{
                self.tagsView.collectionView(self.tagsView.collectionView!, didSelectItemAt: indexPath)
            }
        }
    }

    
}

extension SentenceEditView {
    @IBAction func testButton() {
        //self.tagsView.collectionView?.delegate = self
        let indexPath: IndexPath = IndexPath(row: 1, section: 0)
        //self.tagsView.collectionView(self.tagsView, didSelectItemAt: indexPath)
        self.tagsView.collectionView(self.tagsView.collectionView!, didSelectItemAt: indexPath)
    }

}
