//
//  ViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON
import EZAudio
import C4
import FontAwesome_swift
import RealmSwift

class ViewController: CanvasController, UITextViewDelegate, AVAudioRecorderDelegate, NSURLConnectionDataDelegate, EZMicrophoneDelegate {
    
    @IBOutlet var previewTitleLabel: UILabel!
    @IBOutlet var previewQuestionLabel: UILabel!
    @IBOutlet var beforeChangingTextView: UITextView!
    
    @IBOutlet var afterChangingTextView: UITextView!
    @IBOutlet var previewSelectButton: [BorderButton]!
    
    @IBOutlet var editView: UIView!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var ngButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var voiceInputButton: UIButton!
    
    @IBOutlet var figureView: UIView!
    let docomoSpeakModel: SpeakModel = SpeakModel()
    
    var figureNumberString: String = ""
    var uuid: String = ""
    
    var filePath: String!
    var recorder: AVAudioRecorder!
    
    //効果音
    var changeAnswerAudioPlayer: AVAudioPlayer!
    var singleCursorAudioPlayer: AVAudioPlayer!
    var doubleCursorAudioPlayer: AVAudioPlayer!
    var okAudioPlayer: AVAudioPlayer!
    var recordStartAudioPlayer: AVAudioPlayer!
    
    // 直近タップされたものを記憶
    var needToChangeObjectNumber: Int = 0
    
    var isVoiceInputNow = false
    var bigNumber: Int = 0
    var correctAnswerWithNumber: Int = 0
    
    @IBOutlet var audioPlot: EZAudioPlot!
    var microphone: EZMicrophone!
    
    
    var sounds: SoundManager!
    var speaker: YLSpeechSynthesizer!
    var points = [String: Point]()
    var polygons = [String: Polygon]()
    var prevNote: YLSoundNote? = nil
    
    // 図形領域
    let oosiView = View(frame: Rect(0,289,768,735))

    
    //MARK: Setup and Initializiation Methods
    override func setup() {
        beforeChangingTextView.delegate = self
        afterChangingTextView.delegate = self
        //初期値（仮置き）
        //previewSelectButton[1].backgroundColor = ConstColor.pink
        
        //効果音のための初期化処理
        self.initAudioPlayers()
        
        //Audio Plotのための初期化処理
        self.audioPlotInit()
        self.audioPlot.alpha = 0
        
        
        uuid = ""
        //OOSI Viewの初期化処理
        self.oosiViewInit()
    
        
        self.editView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("SETUP INITIALIZATION")
        
        if NSUserDefaults.standardUserDefaults().objectForKey("uuid") != nil {
            uuid = NSUserDefaults.standardUserDefaults().objectForKey("uuid") as! String
        }
        NSLog("uuid(from UD)===%@",uuid)
        
        if uuid != ""{
            //一覧画面からアクセスした場合
            do {
                let realm = try Realm()
                let object = realm.objects(Question).filter("id = '\(uuid)'").first
                print(object)
                self.reset((object?.name)!, question: (object?.question)!, button1: (object?.answer1)!, button2: (object?.answer2)!, button3: (object?.answer3)!, correctAnswer: (object?.correctAnswer)!, plistFileName: (object?.plistFileName)!)
                
                //OOSI Viewの初期化処理
                
                self.oosiViewInit()
                self.oosiViewResources()
                
                return
                
                
            } catch{
                // handle error
            }
        }else{
            NSLog("FIGURE === %@",figureNumberString)
            self.reset(plistFileName: figureNumberString)
            self.oosiViewResources()
            
        }
        
    }

    
    //MARK: ワンタップ処理 (for only voice output)
    @IBAction func previewTitleLabelPushed(sender: UITapGestureRecognizer) {
        NSLog("PreviewTitleLabel Pushed")
        needToChangeObjectNumber = 5
        docomoSpeakModel.speak(previewTitleLabel.text!)
        self.beforeChangingTextView.text = previewTitleLabel.text
    }
    
    @IBAction func previewQuestionLabelPushed(sender: UITapGestureRecognizer) {
        NSLog("PreviewQuestionLabel Pushed")
        needToChangeObjectNumber = 4
        docomoSpeakModel.speak(previewQuestionLabel.text!)
        self.beforeChangingTextView.text = previewQuestionLabel.text
    }
    
    @IBAction func selectButtonPushed(sender: BorderButton) {
        var buttonTitle = sender.currentTitle
        self.beforeChangingTextView.text = buttonTitle
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("△", withString: "三角形")
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("≡", withString: " 合同 ")
        docomoSpeakModel.speak(buttonTitle!)
        needToChangeObjectNumber = sender.tag
        
    }
    
    @IBAction func okButtonPushed(sender: UIButton) {
        docomoSpeakModel.speak("OKボタン")
    }
    
    @IBAction func ngButtonPushed(sender: UIButton) {
        docomoSpeakModel.speak("編集ボタン")
    }
    
    @IBAction func newButtonPushed(sender: UIButton) {
        docomoSpeakModel.speak("新規作成ボタン")
    }

    //MARK: ダブルタップ処理(UITapGestureRecognizer)
    @IBAction func editButton1DoubleTapped(sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(0)
    }
    @IBAction func editButton2DoubleTapped(sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(1)
    }
    @IBAction func editButton3DoubleTapped(sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(2)
    }
    
    func doubleTappedGeneralWithButtonIndex(index:Int){
        if !changeAnswerAudioPlayer.playing {
            changeAnswerAudioPlayer.play()
            for j in 0...2 {
                previewSelectButton[j].backgroundColor = ConstColor.white
            }
            previewSelectButton[index].backgroundColor = ConstColor.pink
            correctAnswerWithNumber = index
        }
    }
    
    @IBAction func okButtonDoubleTapped(sender: UITapGestureRecognizer) {
        okAudioPlayer.play()
        let afterString = afterChangingTextView.text
        switch needToChangeObjectNumber {
        case 4:
            previewQuestionLabel.text = afterString
            break
        case 5:
            previewTitleLabel.text = afterString
            break
        default:
            previewSelectButton[needToChangeObjectNumber-1].setTitle(afterString, forState: .Normal)
            break
        }
    }
    
    
    @IBAction func voiceInputButtonDoubleTapped(sender: UITapGestureRecognizer) {
        recordStartAudioPlayer.play()
        
        if isVoiceInputNow {
            NSLog("音声入力終了")
            self.stopRecord()
            
            UIView.animateWithDuration(NSTimeInterval(CGFloat(0.5)), animations: { () -> Void in
                self.audioPlot.alpha = 0
                self.voiceInputButton.hidden = true
                self.afterChangingTextView.hidden = false
            })
        }else{
            NSLog("音声入力開始")
            self.startRecord()
            UIView.animateWithDuration(NSTimeInterval(CGFloat(0.5)), animations: {
                self.audioPlot.alpha = 1
            })
            
        }
        
        
    }
    
    @IBAction func ngButtonDoubleTapped(sender: UITapGestureRecognizer) {
        NSLog("編集モード開始")
        editView.hidden = false
        afterChangingTextView.hidden = true
        voiceInputButton.hidden = false
        
        recordStartAudioPlayer.play()
        var setString: String = ""
        
        switch needToChangeObjectNumber {
        case 1:
            setString = previewSelectButton[0].currentTitle!
            break
        case 2:
            setString = previewSelectButton[1].currentTitle!
            break
        case 3:
            setString = previewSelectButton[2].currentTitle!
            break
        case 4:
            setString = previewQuestionLabel.text!
            break
        case 5:
            setString = previewTitleLabel.text!
        default:
            break
        }
        
        beforeChangingTextView.text = setString
    }


    
    //上部ボタン
    @IBAction func newButtonDoubleTapped(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier("QRView", sender: nil)
    }
    
    @IBAction func resetButtonDoubleTapped(sender: UITapGestureRecognizer) {
        NSLog("Reset Button Tapped")
        
        self.reset()
        docomoSpeakModel.speak("すべての入力項目がリセットされました")
    }
    
    
    @IBAction func bigButtonDoubleTapped(sender: UITapGestureRecognizer) {
        bigNumber = bigNumber + 1
        if bigNumber >= 2 {
            bigNumber = -1
        }
        
        var fontSize = 24
        switch bigNumber {
        case -1:
            fontSize = 22
            docomoSpeakModel.speak("やや小さめサイズ")
            break
        case 1:
            fontSize = 26
            docomoSpeakModel.speak("大きめサイズ")
            break
        default:
            docomoSpeakModel.speak("標準サイズ")
            break
        }
        
        
        
        self.previewTitleLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        self.previewQuestionLabel.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        
        for i in 0...2 {
            self.previewSelectButton[i].titleLabel?.font = UIFont.systemFontOfSize(CGFloat(fontSize))
            
        }
        self.beforeChangingTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize))
        self.afterChangingTextView.font = UIFont.systemFontOfSize(CGFloat(fontSize))
    }
    
    
    @IBAction func saveButtonDoubleTapped(sender: UITapGestureRecognizer) {
        self.saveQuestion()
        docomoSpeakModel.speak("問題が保存されました")
    }
    
    
    @IBAction func listButtonDoubleTapped(sender: UITapGestureRecognizer) {
        uuid = ""
        performSegueWithIdentifier("toList", sender: nil)
    }
    
    
    //MARK: TextView Delegate
    func textViewDidChange(textView: UITextView) {
        previewQuestionLabel.text = textView.text
    }

    
    @IBAction func voiceInputButtonPushed(sender: UIButton) {
        
        
    }
    
    
    
    //MARK: Audio Plot Methods
    func audioPlotInit() {
        //波形
        do {
            let session: AVAudioSession = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
            audioPlot.backgroundColor = ConstColor.main
            audioPlot.color = ConstColor.white
            audioPlot.plotType = EZPlotType.Buffer
            audioPlot.shouldFill = true
            audioPlot.shouldMirror = true
            microphone = EZMicrophone(delegate: self)
            microphone.startFetchingAudio()
        }catch{
            
        }
    }
    

    
    // MARK: 大文字など、文字変換
    func changeCharacter(string: String) -> String {
        var bigString = string.uppercaseString
        bigString = bigString.stringByReplacingOccurrencesOfString(" ", withString: "")
        bigString = bigString.stringByReplacingOccurrencesOfString("合同", withString: "≡")
        return bigString
    }
    
    // MARK: Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reset(title: String = "タイトル", question: String = "ここをタップして問題文を入力", button1: String = "選択肢1", button2: String = "選択肢2", button3: String = "選択肢3", correctAnswer: Int = 0, plistFileName: String = "") {
        
        
        previewTitleLabel.text = title
        previewQuestionLabel.text = question
        previewSelectButton[0].setTitle(button1, forState: .Normal)
        previewSelectButton[1].setTitle(button2, forState: .Normal)
        previewSelectButton[2].setTitle(button3, forState: .Normal)
        
        if correctAnswer != 0 {
            doubleTappedGeneralWithButtonIndex(correctAnswer-1)
        }
        
        figureNumberString = plistFileName
        
        
    }
 
}

