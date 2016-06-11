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

class ViewController: CanvasController, UITextViewDelegate, AVAudioRecorderDelegate, NSURLConnectionDataDelegate, EZMicrophoneDelegate {
    
    @IBOutlet var previewQuestionLabel: UILabel!
    @IBOutlet var editingTextView: UITextView!
    @IBOutlet var previewSelectButton: [BorderButton]!
    
    @IBOutlet var okButton: UIButton!
    @IBOutlet var ngButton: UIButton!
    
    
    let docomoSpeakModel: SpeakModel = SpeakModel()
    
    var filePath: String!
    var recorder: AVAudioRecorder!
    
    //効果音
    var changeAnswerAudioPlayer: AVAudioPlayer!
    var singleCursorAudioPlayer: AVAudioPlayer!
    var doubleCursorAudioPlayer: AVAudioPlayer!
    var okAudioPlayer: AVAudioPlayer!
    var recordStartAudioPlayer: AVAudioPlayer!
    
    //直近タップされたものを記憶
    var needToChangeObjectNumber: Int = 0
    
    var isVoiceInputNow = false
    
    @IBOutlet var audioPlot: EZAudioPlot!
    var microphone: EZMicrophone!
    
    
    var sounds: SoundManager!
    var speaker: YLSpeechSynthesizer!
    var points = [String: Point]()
    var polygons = [String: Polygon]()
    var prevNote: YLSoundNote? = nil
    
    let oosiView = View(frame: Rect(0,289,768,735))
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        editingTextView.delegate = self
        //初期値（仮置き）
        previewSelectButton[1].backgroundColor = ConstColor.pink
        
        //音声合成のための初期化処理
        self.initAudioPlayers()
        
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
    }*/
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        let weakSelf = self
        dispatch_async(dispatch_get_main_queue(),{
            weakSelf.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioStreamBasicDescription audioStreamBasicDescription: AudioStreamBasicDescription) {
        EZAudioUtilities.printASBD(audioStreamBasicDescription)
    }
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ONE TAP METHODS FOR ONLY VOICE OUTPUT
    @IBAction func previewQuestionLabelPushed(sender: UITapGestureRecognizer) {
        //1回タップで音声合成。
        NSLog("PreviewQuestionLabel Pushed")
        needToChangeObjectNumber = 4
        docomoSpeakModel.speak(previewQuestionLabel.text!)
    }
    
    @IBAction func selectButtonPushed(sender: BorderButton) {
        //1回タップで音声合成。
        var buttonTitle = sender.currentTitle
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("△", withString: "三角形")
        buttonTitle = buttonTitle?.stringByReplacingOccurrencesOfString("≡", withString: " 合同 ")
        docomoSpeakModel.speak(buttonTitle!)
        
        needToChangeObjectNumber = sender.tag
    }
    
    @IBAction func okButtonPushed(sender: UIButton) {
        docomoSpeakModel.speak("OKボタン")
    }
    
    @IBAction func ngButtonPushed(sender: UIButton) {
        docomoSpeakModel.speak(String(sender.currentTitle!) + "ボタン")
    }
    
    //MARK: ダブルタップ処理
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
        }
    }
    
    @IBAction func okButtonDoubleTapped(sender: UITapGestureRecognizer) {
        okAudioPlayer.play()
    }
    @IBAction func ngButtonDoubleTapped(sender: UITapGestureRecognizer) {
        NSLog("編集モード開始")
        singleCursorAudioPlayer.play()
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
        default:
            break
        }
        
        editingTextView.text = setString
    }

    @IBAction func voiceInputDoubleTapped(sender: UITapGestureRecognizer) {
        recordStartAudioPlayer.play()
        if isVoiceInputNow {
            NSLog("音声入力終了")
            self.stopRecord()
        }else{
            NSLog("音声入力開始")
            self.startRecord()
        }
        
    }
    
    //MARK: TextView処理
    func textViewDidChange(textView: UITextView) {
        previewQuestionLabel.text = textView.text
    }
    
    @IBAction func saveButtonDoubleTapped(sender: UITapGestureRecognizer) {
        NSLog("Save Button Double Tapped")
        
    }
    
    @IBAction func voiceInputButtonPushed(sender: UIButton) {

    }
    
    //MARK: METHODS
    
    
    //NSURLDataDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        
        let json = JSON(data: data)
        NSLog("データを受け取りました")
        print(json)
        if let resultString = json["result"][0]["alternative"][0]["transcript"].string {
            //Now you got your value
            NSLog("google result == %@",resultString)
            //音声認識結果をテキストビューに表示
            editingTextView.text = resultString
            docomoSpeakModel.speak(resultString)
        }
        isVoiceInputNow = false
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("ERROR == %@",error)
        isVoiceInputNow = false
    }
    
    //MARK: Google Speech API
    func callGoogleRecognizeApi(data: NSData) {
        NSLog("CALL GOOGLE RECOGNIZE API")
        var googleSpeechAPIKey: String = ""
        
        
        //APIキーを読み込み
        if let speechAPIKEY = KeyManager().getValue("GoogleSpeechAPIKey") as? String {
            googleSpeechAPIKey = speechAPIKEY
        }
        
        let urlStr = NSString.localizedStringWithFormat("https://www.google.com/speech-api/v2/recognize?xjerr=1&client=chromium&lang=ja-JP&maxresults=10&pfilter=0&xjerr=1&key=%@", googleSpeechAPIKey)
        let url: NSURL = NSURL(string: urlStr as String)!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("audio/l16; rate=16000", forHTTPHeaderField: "Content-Type")
        request.addValue("chromium", forHTTPHeaderField: "client")
        request.HTTPBody = data
        
        NSURLConnection(request: request, delegate: self)
        
        
    }
    
    func startRecord() {
        isVoiceInputNow = true
        self.filePath = self.makeFilePath()
        do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            let settings: NSDictionary = [
                AVFormatIDKey: NSNumber.init(unsignedInt: kAudioFormatLinearPCM),
                AVSampleRateKey: NSNumber.init(float: 16000.0),
                AVNumberOfChannelsKey: NSNumber.init(unsignedInt: 1),
                AVLinearPCMBitDepthKey: NSNumber.init(unsignedInt: 16)
            ]
            do {
                self.recorder = try AVAudioRecorder(URL: NSURL.init(string: self.filePath as String)!, settings: settings as! [String : AnyObject])
                self.recorder.delegate = self
                self.recorder.prepareToRecord()
                self.recorder.recordForDuration(15.0)
            }catch{
            }
        }catch{
        }
    }
    
    func stopRecord() {
        isVoiceInputNow = false
        self.recorder.stop()
    }
    
    func makeFilePath() -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let fileName: String = String(format: "%@.wav", formatter.stringFromDate(NSDate()))
        return NSTemporaryDirectory().stringByAppendingString(fileName)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            return
        }
        let data: NSData = NSData(contentsOfFile: self.filePath)!
        self.callGoogleRecognizeApi(data)
    }
    
    
    
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
    
    
    
    override func setup() {
        
        editingTextView.delegate = self
        //初期値（仮置き）
        previewSelectButton[1].backgroundColor = ConstColor.pink
        
        //音声合成のための初期化処理
        self.initAudioPlayers()
        
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

        

        oosiView.backgroundColor = black
        canvas.add(oosiView)
        
        speaker = YLSpeechSynthesizer()
        let parser = DemoPropParser(YLResource.loadBundleResource("Demo"))
        points = parser.getPoints()
        polygons = parser.getPolygons()
        sounds = SoundManager(YLResource.loadBundleResource("resources"))
        
        oosiView.addPanGestureRecognizer { _, center, _, _, _ in
            self.onPanning(center)
        }
        
        addViews(Array(parser.getCircles().values),
                 Array(polygons.values),
                 Array(parser.getLabels().values),
                 Array(parser.getAngles().values))
    }
    
    func addViews(circles: [Circle], _ polygons: [Polygon], _ labels: [TextShape], _ angles: [Wedge]) {
        for p in polygons {
            oosiView.add(p)
        }
        for c in circles {
            oosiView.add(c)
            c.addTapGestureRecognizer { _, center, _ in
                print("Point:", center)
                self.sounds.pong()
                c.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: 1)
            }
        }
        for a in angles {
            oosiView.add(a)
        }
        for l in labels {
            oosiView.add(l)
            l.addTapGestureRecognizer { _ in
                self.speaker.speak(l.text)
            }
        }
    }
    
    func onPanning(center: Point) {
        print(center)
        let ps = polygons.filter { _, polygon in
            polygon.hitTest(center)
        }
        if let (name, _) = ps.first {
            let i = name.startIndex
            let ch = "\(name[i])"
            let begin = conv(points[ch]!)
            let d = distance(begin, rhs: center)
            self.pip(d)
            print("Line:", begin, center)
        } else {
            prevNote = nil
        }
    }
    
    func pip(distance: Double) {
        let note = YLSoundNote(rawValue: Int(distance)/15)!
        if let pr = prevNote {
            if pr != note {
                sounds.pip(note)
            }
        } else {
            sounds.pip(note)
        }
        prevNote = note
        
    }
    

 
}

