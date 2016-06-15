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
    
    private let targetTypes = [AVMetadataObjectTypeQRCode]
    
    // キャプチャセッションを作成
    private let session = AVCaptureSession()
    // 専用のキューを作成
    private let sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL)

    
    let docomoSpeakModel: SpeakModel = SpeakModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // プレビュー用のレイヤーを作成
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        qrView.layer.addSublayer(layer)
        previewLayer = layer
        
        dispatch_async(sessionQueue) {
            // カメラの取得と設定
            let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).flatMap {
                ($0.position == .Back) ? $0 : nil
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
            output.setMetadataObjectsDelegate(self, queue: dispatch_queue_create("meta queue", DISPATCH_QUEUE_SERIAL))
            self.session.addOutput(output)
            output.metadataObjectTypes = self.targetTypes
        }

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // キャプチャセッションを開始
        dispatch_async(sessionQueue) {
            self.session.startRunning()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // プレビューのサイズを合わせる
        previewLayer.frame = qrView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        typealias code = (value: String, rect: CGRect)
        
        let items: [code] = metadataObjects.flatMap {
            guard let obj = $0 as? AVMetadataMachineReadableCodeObject else { return nil }
            // ターゲットとするタイプのコードか確認
            guard let _ = targetTypes.indexOf(obj.type) else { return nil }
            
            // コードのタイプとデータを取得
            let value = (obj.type.componentsSeparatedByString(".").last ?? "") + "\n" + obj.stringValue
            let rect = previewLayer.transformedMetadataObjectForMetadataObject(obj).bounds
            
            return (value: value, rect: rect)
        }
        
        // マーカーの追加
        dispatch_async(dispatch_get_main_queue()) {
            self.qrView.subviews.forEach { $0.removeFromSuperview() }
            items.forEach {
                let v = UIView(frame: $0.rect)
                v.backgroundColor = UIColor.clearColor()
                v.layer.borderColor = UIColor.greenColor().CGColor
                v.layer.borderWidth = 2
                let lb = UILabel(frame: v.bounds)
                lb.numberOfLines = -1
                lb.adjustsFontSizeToFitWidth = true
                lb.text = $0.value
                lb.textAlignment = .Center
                lb.center = CGPoint(x: v.bounds.width / 2, y: v.bounds.height / 2)
                lb.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3)
                lb.textColor = UIColor.yellowColor()
                v.addSubview(lb)
                print(lb.text)
                self.qrView.addSubview(v)
            }
        }
    }

}
