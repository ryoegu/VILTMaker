//
//  QRReaderViewController.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/31.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import AVFoundation

class QRReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet var qrView: UIView!
    
    fileprivate let targetTypes = [AVMetadataObjectTypeQRCode]
    
    var figureNumberString: String!
    
    // キャプチャセッションを作成
    fileprivate let session = AVCaptureSession()
    // 専用のキューを作成
    fileprivate let sessionQueue = DispatchQueue(label: "session queue", attributes: [])

    
    let docomoSpeakModel: SpeakModel = SpeakModel()
    var doubleCursorAudioPlayer: AVAudioPlayer!
    let saveData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initAudioPlayers()
        
        // プレビュー用のレイヤーを作成
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        qrView.layer.addSublayer(layer!)
        previewLayer = layer
        
        sessionQueue.async {
            // カメラの取得と設定
            let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).flatMap {
                (($0 as AnyObject).position == .front) ? $0 : nil
            }
            guard let device = devices.first as? AVCaptureDevice else {
                assertionFailure("Not Found Camera")
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: device)
                self.session.addInput(input)
            } catch let error as NSError {
                assertionFailure(error.debugDescription)
                return
            }
            
            let output = AVCaptureMetadataOutput()
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "meta queue", attributes: []))
            self.session.addOutput(output)
            output.metadataObjectTypes = self.targetTypes
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // キャプチャセッションを開始
        sessionQueue.async {
            self.session.startRunning()
        }
        let image: UIImage = UIImage(named: "welcome.png")!
        let imageView: UIImageView = UIImageView(image: image)
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        imageView.frame = rect
        self.view.addSubview(imageView)
        
        //発音を開始
        docomoSpeakModel.speak("QRコードを読み込んでください。")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // プレビューのサイズを合わせる
        previewLayer.frame = qrView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        typealias code = (value: String, rect: CGRect)
        
        let items: [code] = metadataObjects.flatMap {
            guard let obj = $0 as? AVMetadataMachineReadableCodeObject else { return nil }
            // ターゲットとするタイプのコードか確認
            guard let _ = targetTypes.index(of: obj.type) else { return nil }
            
            // コードのタイプとデータを取得
            let value = (obj.type.components(separatedBy: ".").last ?? "") + "\n" + obj.stringValue
            let rect = previewLayer.transformedMetadataObject(for: obj).bounds
            if !self.doubleCursorAudioPlayer.isPlaying {
                self.doubleCursorAudioPlayer.play()
                DispatchQueue.main.async(execute: {

                    // Main Thread
                    self.figureNumberString = obj.stringValue
                
                    self.performSegue(withIdentifier: "QuestionView", sender: nil)
                });

                
                }
            return (value: value, rect: rect)
        }
        
         // マーカーの追加
        DispatchQueue.main.async {
            self.qrView.subviews.forEach { $0.removeFromSuperview() }
            items.forEach {
                let v = UIView(frame: $0.rect)
                v.backgroundColor = UIColor.clear
                v.layer.borderColor = UIColor.green.cgColor
                v.layer.borderWidth = 2
                let lb = UILabel(frame: v.bounds)
                lb.numberOfLines = -1
                lb.adjustsFontSizeToFitWidth = true
                lb.text = $0.value
                lb.textAlignment = .center
                lb.center = CGPoint(x: v.bounds.width / 2, y: v.bounds.height / 2)
                lb.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
                lb.textColor = UIColor.yellow
                v.addSubview(lb)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QuestionView" {
            saveData.set("", forKey: "uuid")
            let mainView: ViewController = segue.destination as! ViewController
            mainView.figureNumberString = self.figureNumberString
            
            self.session.stopRunning()
            
        }
    }
    
    //MARK: Set Audio Player(効果音)
    func initAudioPlayers() {
        //Single Cursor
        do {
            let filePath = Bundle.main.path(forResource: "cursorDouble", ofType: "mp3")
            let audioPath = URL(fileURLWithPath: filePath!)
            doubleCursorAudioPlayer = try AVAudioPlayer(contentsOf: audioPath)
            doubleCursorAudioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
    }

}
