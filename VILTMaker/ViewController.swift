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
import Realm
import RealmSwift
import Speech
import UITags
import Spring
import MultipeerConnectivity

class ViewController: CanvasController, UITextViewDelegate, AVAudioRecorderDelegate, EZMicrophoneDelegate {
    
    /* Preview Area Objects */
    @IBOutlet var previewTitleLabel: UILabel!
    @IBOutlet var previewQuestionLabel: UILabel!
    @IBOutlet var previewSelectButton: [BorderButton]!
    // Figure View
    let oosiView = View(frame: Rect(0,289,768,735))
    
    
    /* Common Area Objects */
    @IBOutlet var commonButtons: [BorderButton]!
    
    /* Custom Objects */
    
    var editView: SentenceEditView!
    var speedChangeView: SpeedChangeView!
    var voiceInputView: VoiceInputView!
    
    /* Voice and Microphone Objects */
    @IBOutlet var afterChangingTextView: UITextView!
    @IBOutlet var audioPlot: EZAudioPlot!
    
    
    
    @IBOutlet var saveButton: UIButton!
    
    
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
    
    var bigNumber: Int = 0
    var correctAnswerWithNumber: Int = 0
    
    
    var microphone: EZMicrophone!
    
    var sounds: SoundManager!
    var speaker: YLSpeechSynthesizer!
    var points = [String: Point]()
    var polygons = [String: Polygon]()
    var prevNote: YLSoundNote? = nil

    
    @IBOutlet var gestureInterface: UIView!
    
    var selectedObject: Int = 0
    
    //音声認識
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja_JP"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    let audioEngine: AVAudioEngine = AVAudioEngine()
    var recognitionTask: SFSpeechRecognitionTask!
    
    //音声認識された言葉の配列
    var analyzedStringArray: [String]!
    
    //Multipeer Connectivity
    var peerID:MCPeerID!
    var session:MCSession!
    var browser:MCNearbyServiceBrowser!
    var advertiser:MCNearbyServiceAdvertiser? = nil
    @IBOutlet var statusLabel: UILabel!
    
    var figureDictionary: Dictionary<String,Any>!
    
    @IBOutlet var leftView: UIView!
    
    var gestureCount: Int = 0
    var editTime: Float = 0.0
    var tim = Timer()
    
    //MARK: Setup and Initializiation Methods
    override func setup() {
        editView = SentenceEditView(frame: CGRect(x: 785, y: 150, width: 576, height: 400))
        speedChangeView = SpeedChangeView(frame: CGRect(x: 785, y: 800, width: 576, height: 200))
        
        voiceInputView = VoiceInputView(frame: CGRect(x: 785, y: 600, width: 576, height: 150))

        
        self.view.addSubview(editView)
        self.view.addSubview(speedChangeView)
        self.view.addSubview(voiceInputView)
        
        afterChangingTextView.delegate = self
        //初期値（仮置き）
        //previewSelectButton[1].backgroundColor = ConstColor.pink
        
        //効果音のための初期化処理
        self.initAudioPlayers()
        
        //Audio Plotのための初期化処理
        self.audioPlotInit()
        self.audioPlot.alpha = 0
        
        
        //OOSI Viewの初期化処理
        self.oosiViewInit()
        
        //Trackpad Interfaceの初期化処理
        self.trackpadInterfaceInit()
    
                
        //音声認識のため
        speechRecognizer?.delegate = self
        
        
    }
    
    func update() {
        editTime = editTime + 0.01
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !tim.isValid {
            tim = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
        if uuid != "" {
            //一覧画面からアクセスした場合
            do {
                let realm = try! Realm()

                
                let object = realm.objects(Question.self).filter("id = '\(uuid)'").first
                self.reset((object?.name)!, question: (object?.question)!, button1: (object?.answer1)!, button2: (object?.answer2)!, button3: (object?.answer3)!, correctAnswer: (object?.correctAnswer)!, figureDictionaryData: (object?.oosiDictionaryData)!)
                
                //OOSI Viewの初期化処理
                
                self.oosiViewInit()
                self.oosiViewResources(figureDictionary)
                
                return
                
                
            } catch{
                // handle error
            }
        }
//        else if figureNumberString != ""{
//            //QRコード画面からアクセスした場合
//            NSLog("FIGURE === %@",figureNumberString)
//            //self.reset(plistFileName: figureNumberString)
//            //self.oosiViewResources()
//            
//        }
        else{
            //点図読み取り画面からアクセスした場合
            self.reset()
            self.oosiViewResources(figureDictionary)
            
        }
        self.selectedObject = 0
        gestureFunction()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.setupSession() //Bluetooth Connect to VILT Controller

        self.requestAPI()
    }

    
    //MARK: ワンタップ処理 (for only voice output)
    @IBAction func previewTitleLabelPushed(_ sender: UITapGestureRecognizer) {
        NSLog("PreviewTitleLabel Pushed")
        needToChangeObjectNumber = 0
        selectedObject = 0
        self.gestureFunction()
        
        
    }
    
    @IBAction func previewQuestionLabelPushed(_ sender: UITapGestureRecognizer) {
        NSLog("PreviewQuestionLabel Pushed")
        needToChangeObjectNumber = 1
        selectedObject = 1
        self.gestureFunction()
    }
    
    @IBAction func selectButtonPushed(_ sender: BorderButton) {
        var buttonTitle = sender.currentTitle
        buttonTitle = buttonTitle?.replacingOccurrences(of: "△", with: "三角形")
        buttonTitle = buttonTitle?.replacingOccurrences(of: "≡", with: " 合同 ")
        selectedObject = sender.tag + 1
        self.gestureFunction()
        needToChangeObjectNumber = sender.tag + 1
        
    }
    
    /*  使用していない (HIS 2016版で使用) */
    @IBAction func okButtonPushed(_ sender: UIButton) {
        docomoSpeakModel.speak("OKボタン")
    }
    
    @IBAction func ngButtonPushed(_ sender: UIButton) {
        docomoSpeakModel.speak("編集ボタン")
    }
    /*  ここまで */
    
    @IBAction func newButtonPushed(_ sender: UIButton) {
        selectedObject = 6
        gestureFunction()
    }
    
    @IBAction func resetButtonPushed(_ sender: UIButton) {
        selectedObject = 7
        gestureFunction()
    }
    
    @IBAction func voiceSpeedChangeButtonPushed(_ sender: UIButton) {
        selectedObject = 8
        gestureFunction()
    }
    
    @IBAction func saveButtonPushed(_ sender: UIButton) {
        selectedObject = 9
        gestureFunction()
    }
    
    @IBAction func listButtonPushed(_ sender: UIButton) {
        selectedObject = 10
        gestureFunction()
    }

    //MARK: ダブルタップ処理(UITapGestureRecognizer)
    @IBAction func editButton1DoubleTapped(_ sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(0)
    }
    @IBAction func editButton2DoubleTapped(_ sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(1)
    }
    @IBAction func editButton3DoubleTapped(_ sender: UITapGestureRecognizer) {
        self.doubleTappedGeneralWithButtonIndex(2)
    }
    
    func doubleTappedGeneralWithButtonIndex(_ index:Int){
        if !changeAnswerAudioPlayer.isPlaying {
            changeAnswerAudioPlayer.play()
            for j in 0...2 {
                previewSelectButton[j].backgroundColor = ConstColor.white
            }
            previewSelectButton[index].backgroundColor = ConstColor.pink
            correctAnswerWithNumber = index
        }
    }
    
    @IBAction func okButtonDoubleTapped(_ sender: UITapGestureRecognizer) {
        okAudioPlayer.play()
        let afterString = afterChangingTextView.text
        switch needToChangeObjectNumber {
        case 1:
            previewQuestionLabel.text = afterString
            break
        case 0:
            previewTitleLabel.text = afterString
            break
        default:
            previewSelectButton[needToChangeObjectNumber-2].setTitle(afterString, for: UIControlState())
            break
        }
    }

    //上部ボタン
    @IBAction func newButtonDoubleTapped(_ sender: UITapGestureRecognizer) {
        selectedObject = 6
        tapGesture()
    }
    
    func newDocument() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonDoubleTapped(_ sender: UITapGestureRecognizer) {
        NSLog("Reset Button Tapped")
        
        selectedObject = 7
        tapGesture()

    }
    
    
    @IBAction func bigButtonDoubleTapped(_ sender: UITapGestureRecognizer) {
        selectedObject = 8
        tapGesture()
        /*bigNumber = bigNumber + 1
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
        
        self.previewTitleLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        self.previewQuestionLabel.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        
        for i in 0...2 {
            self.previewSelectButton[i].titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            
        }
        self.afterChangingTextView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))*/
    }
    
    
    @IBAction func saveButtonDoubleTapped(_ sender: UITapGestureRecognizer) {
        self.saveQuestion()
    }
    
    
    @IBAction func listButtonDoubleTapped(_ sender: UITapGestureRecognizer) {
        uuid = ""
        performSegue(withIdentifier: "toList", sender: nil)
    }
    
    //MARK: TextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        previewQuestionLabel.text = textView.text
    }

    
    // MARK: Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reset(_ title: String = "タイトル", question: String = "問題文エリア", button1: String = "選択肢1", button2: String = "選択肢2", button3: String = "選択肢3", correctAnswer: Int = 0, figureDictionaryData: Data? = nil) {
        
        
        previewTitleLabel.text = title
        previewQuestionLabel.text = question
        previewSelectButton[0].setTitle(button1, for: UIControlState())
        previewSelectButton[1].setTitle(button2, for: UIControlState())
        previewSelectButton[2].setTitle(button3, for: UIControlState())
        
        if correctAnswer != 0 {
            doubleTappedGeneralWithButtonIndex(correctAnswer-1)
        }
        
//        figureNumberString = plistFileName
 
        
        if figureDictionaryData != nil {
            self.figureDictionary = NSKeyedUnarchiver.unarchiveObject(with: figureDictionaryData!) as! Dictionary<String, Any>!
        }
    }
    

}

