//
//  DrawViewController.swift
//
//  Created by Yuji Yamazaki on 2016/12/05.
//  Copyright © 2016年 Yuji Yamazaki. All rights reserved.
//

import UIKit
import Photos

class DrawViewController: UIViewController, UIScrollViewDelegate,UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var canvasView: UIImageView!
    
    var lastPoint: CGPoint?                 //直前のタッチ座標の保存用
    var lineWidth: CGFloat = 30.0                //描画用の線の太さの保存用
    //var bezierPath = UIBezierPath()         //お絵描きに使用
    var bezierPath: UIBezierPath?           //お絵描きに使用
    var drawColor = UIColor()               //描画色の保存用
    var currentDrawNumber = 0               //現在の表示しているは何回めのタッチか
    var saveImageArray = [UIImage]()        //Undo/Redo用にUIImageを保存
    
    //let defaultLineWidth: CGFloat = 10.0    //デフォルトの線の太さ
    let scale = CGFloat(30)                   //線の太さに変換するためにSlider値にかける係数
    
    var interactionController : UIDocumentInteractionController?

    
    //CSVファイルの保存先
    var userPath:String!
    
    let fileManager = FileManager()
    
    let INIT_LINE_NUMBER = 1
    var lineNumber = 1
    let INIT_POINT_NUMBER = 2
    var pointNumber = 1
    
    var pointDic = [String:Any]()
    var dataDictionary = [String:Any]()
    
    //開始位置を保持
    var beganTouchPoint: CGPoint = CGPoint()
    
    //Timer
    var timer: Timer = Timer()
    
    var drawTime: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineNumber = INIT_LINE_NUMBER
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0                   // 最小拡大率
        scrollView.maximumZoomScale = 1.0                   // 最大拡大率
        scrollView.zoomScale = 1.0                          // 表示時の拡大率(初期値)
        
        prepareDrawing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
    }
    
    func update() {
        drawTime = drawTime + 0.01
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(drawTime, forKey: "drawTime")
        print(drawTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     拡大縮小に対応
     */
    //func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      //  return self.canvasView
    //}
    
    /**
     UIGestureRecognizerでお絵描き対応。1本指でなぞった時のみの対応とする。
     */
    fileprivate func prepareDrawing() {
        
        //実際のお絵描きで言う描く手段(色えんぴつ？クレヨン？絵の具？など)の準備
        let myDraw = UIPanGestureRecognizer(target: self, action: #selector(DrawViewController.drawGesture(_:)))
        myDraw.maximumNumberOfTouches = 1
        self.scrollView.addGestureRecognizer(myDraw)
        
        drawColor = UIColor.yellow                           //draw色を黒色に決定する
        //lineWidth = CGFloat(sliderValue.value) * scale    //線の太さを決定する
        
        //実際のお絵描きで言うキャンバスの準備 (=何も描かれていないUIImageの作成)
        prepareCanvas()
        
        saveImageArray.append(self.canvasView.image!)       //配列にcanvasView.imageを保存
        
    }
    
    /**
     キャンバスの準備 (何も描かれていないUIImageの作成)
     */
    func prepareCanvas() {
        //キャンバスのサイズの決定
        //let canvasSize = CGSize(width: view.frame.width * 2, height: view.frame.width * 2)
        let canvasSize = CGSize(width: 768, height: 735)
        
        //キャンバスのRectの決定
        let canvasRect = CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height)
        //コンテキスト作成(キャンバスのUIImageを作成する為)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        //キャンバス用UIImage(まだ空っぽ)
        var firstCanvasImage = UIImage()
        //白色塗りつぶし作業1
        UIColor.black.setFill()
        //白色塗りつぶし作業2
        UIRectFill(canvasRect)
        //firstCanvasImageの内容を描く(真っ白)
        firstCanvasImage.draw(in: canvasRect)
        firstCanvasImage = UIGraphicsGetImageFromCurrentImageContext()!              //何も描かれてないUIImageを取得
        canvasView.contentMode = .scaleAspectFit                                    //contentModeの設定
        canvasView.image = firstCanvasImage                                       //画面の表示を更新
        UIGraphicsEndImageContext()                                                 //コンテキストを閉じる
    }
    
    
    /**
     draw動作
     */
    func drawGesture(_ sender: AnyObject) {
        
        guard let drawGesture = sender as? UIPanGestureRecognizer else {
            print("drawGesture Error happened.")
            return
        }
        
        guard let canvas = self.canvasView.image else {
            fatalError("self.pictureView.image not found")
        }
        
        //lineWidth = defaultLineWidth                                    //描画用の線の太さを決定する
        //drawColor = UIColor.blackColor()                                //draw色を決定する
        let touchPoint = drawGesture.location(in: canvasView)         //タッチ座標を取得
        print("TOUCH POINT===(\(touchPoint.x),\(touchPoint.y))")
        
        switch drawGesture.state {
        case .began:
            lastPoint = touchPoint
            //タッチ座標をlastTouchPointとして保存する
            beganTouchPoint = touchPoint
            
            print("start=(\(touchPoint.x),\(touchPoint.y))")
            setData(num: lineNumber, pos: touchPoint)
            //touchPointの座標はscrollView基準なのでキャンバスの大きさに合わせた座標に変換しなければいけない
            //LastPointをキャンバスサイズ基準にConvert
            let lastPointForCanvasSize = convertPointForCanvasSize(originalPoint: lastPoint!, canvasSize: canvas.size)
            
            bezierPath = UIBezierPath()
            guard let bzrPth = bezierPath else {
                fatalError("bezierPath Error")
            }
            
            bzrPth.lineCapStyle = .round                            //描画線の設定 端を丸くする
            //bzrPth.lineWidth = defaultLineWidth                     //描画線の太さ
            bzrPth.lineWidth = lineWidth                           //描画線の太さ
            bzrPth.move(to: lastPointForCanvasSize)
            
        case .changed:
            
            let newPoint = touchPoint                                   //タッチポイントを最新として保存
            
            guard let bzrPth = bezierPath else {
                fatalError("bezierPath Error")
            }
            
            //Draw実行しDraw後のimage取得
            let imageAfterDraw = drawGestureAtChanged(canvas, lastPoint: lastPoint!, newPoint: newPoint, bezierPath: bzrPth)
            
            self.canvasView.image = imageAfterDraw                      //Draw画像をCanvasに上書き
            lastPoint = newPoint                                        //Point保存
            
        case .ended:
            
            //currentDrawNumberとsaveImageArray配列数が矛盾無きまでremoveLastする
            while currentDrawNumber != saveImageArray.count - 1 {
                saveImageArray.removeLast()
            }
            
            currentDrawNumber += 1
            saveImageArray.append(self.canvasView.image!)               //配列にcanvasView.imageを保存
            
            if currentDrawNumber != saveImageArray.count - 1 {
                fatalError("index Error")
            }
            
            //print("Finish dragging")
            print("finish=(\(touchPoint.x),\(touchPoint.y))")
            setData(num: lineNumber, pos: touchPoint)
//            setData(num: lineNumber, startPos: beganTouchPoint, finishPos: touchPoint)
            
            lineNumber += 1
            
        default:
            ()
        }
        
    }
    

    func setData(num: Int, pos: CGPoint) {
        var posDic = [String:Double]()
        posDic["x"] = Double(pos.x)
        posDic["y"] = Double(pos.y)
        
        
        
        pointDic["\(convertToAlphabet(pointNumber))"] = posDic
        
        pointNumber += 1
    }
    
    
    func convertToAlphabet(_ num: Int) -> String {
        var returnString = ""
        switch num {
        case 1:
            returnString = "A"
        case 2:
            returnString = "B"
        case 3:
            returnString = "C"
        case 4:
            returnString = "D"
        case 5:
            returnString = "E"
        case 6:
            returnString = "F"
        case 7:
            returnString = "G"
        case 8:
            returnString = "H"
        case 9:
            returnString = "I"
        case 10:
            returnString = "J"
        case 11:
            returnString = "K"
        case 12:
            returnString = "L"
        case 13:
            returnString = "M"
        case 14:
            returnString = "N"
        case 15:
            returnString = "O"
        case 16:
            returnString = "P"
        case 17:
            returnString = "Q"
        case 18:
            returnString = "R"
        case 19:
            returnString = "S"
        case 20:
            returnString = "T"
        case 21:
            returnString = "U"
        case 22:
            returnString = "V"
        case 23:
            returnString = "W"
        case 24:
            returnString = "X"
        case 25:
            returnString = "Y"
        case 26:
            returnString = "Z"
        default:
            returnString = "Z"
        }
        
        return returnString
    }

    /**
     UIGestureRecognizerのStatusが.Changedの時に実行するDraw動作
     
     - parameter canvas : キャンバス
     - parameter lastPoint : 最新のタッチから直前に保存した座標
     - parameter newPoint : 最新のタッチの座標座標
     - parameter bezierPath : 線の設定などが保管されたインスタンス
     - returns : 描画後の画像
     */
    func drawGestureAtChanged(_ canvas: UIImage, lastPoint: CGPoint, newPoint: CGPoint, bezierPath: UIBezierPath) -> UIImage {
        
        //最新のtouchPointとlastPointからmiddlePointを算出
        let middlePoint = CGPoint(x: (lastPoint.x + newPoint.x) / 2, y: (lastPoint.y + newPoint.y) / 2)
        
        //各ポイントの座標はscrollView基準なのでキャンバスの大きさに合わせた座標に変換しなければいけない
        //各ポイントをキャンバスサイズ基準にConvert
        let middlePointForCanvas = convertPointForCanvasSize(originalPoint: middlePoint, canvasSize: canvas.size)
        let lastPointForCanvas   = convertPointForCanvasSize(originalPoint: lastPoint, canvasSize: canvas.size)
        
        bezierPath.addQuadCurve(to: middlePointForCanvas, controlPoint: lastPointForCanvas)  //曲線を描く
        UIGraphicsBeginImageContextWithOptions(canvas.size, false, 0.0)                 //コンテキストを作成
        let canvasRect = CGRect(x: 0, y: 0, width: canvas.size.width, height: canvas.size.height)        //コンテキストのRect
        self.canvasView.image?.draw(in: canvasRect)                                   //既存のCanvasを準備
        drawColor.setStroke()                                                           //drawをセット
        bezierPath.stroke()                                                             //draw実行
        let imageAfterDraw = UIGraphicsGetImageFromCurrentImageContext()                //Draw後の画像
        UIGraphicsEndImageContext()                                                     //コンテキストを閉じる
        
        return imageAfterDraw!
    }
    
    /**
     (おまじない)座標をキャンバスのサイズに準じたものに変換する
     
     - parameter originalPoint : 座標
     - parameter canvasSize : キャンバスのサイズ
     - returns : キャンバス基準に変換した座標
     */
    func convertPointForCanvasSize(originalPoint: CGPoint, canvasSize: CGSize) -> CGPoint {
        
        let viewSize = scrollView.frame.size
        var ajustContextSize = canvasSize
        var diffSize: CGSize = CGSize(width: 0, height: 0)
        let viewRatio = viewSize.width / viewSize.height
        let contextRatio = canvasSize.width / canvasSize.height
        let isWidthLong = viewRatio < contextRatio ? true : false
        
        if isWidthLong {
            
            ajustContextSize.height = ajustContextSize.width * viewSize.height / viewSize.width
            diffSize.height = (ajustContextSize.height - canvasSize.height) / 2
            
        } else {
            
            ajustContextSize.width = ajustContextSize.height * viewSize.width / viewSize.height
            diffSize.width = (ajustContextSize.width - canvasSize.width) / 2
            
        }
        
        let convertPoint = CGPoint(x: originalPoint.x * ajustContextSize.width / viewSize.width - diffSize.width,
                                   y: originalPoint.y * ajustContextSize.height / viewSize.height - diffSize.height)
        
        
        return convertPoint
        
    }

    
    /**
     Blackボタンを押した時の動作
     ペンを黒色にする
     */
    @IBAction func selecBlack(_ sender: AnyObject) {
        
        drawColor = UIColor.black    //黒色に変更する
    }
    
    /**
     Undoボタンを押した時の動作
     Undoを実行する
     */
    @IBAction func pressUndoButton(_ sender: AnyObject) {
        
        if currentDrawNumber <= 0 {return}
        
        self.canvasView.image = saveImageArray[currentDrawNumber - 1]   //保存している直前imageに置き換える
        
        currentDrawNumber -= 1
        
        if lineNumber > INIT_LINE_NUMBER {
            lineNumber -= 1
        }
        if pointNumber > INIT_POINT_NUMBER {
            pointNumber -= 2
        }
        
    }
    
    /**
     Redoボタンを押した時の動作
     Redoを実行する
     */
    @IBAction func pressRedoButton(_ sender: AnyObject) {
        
        if currentDrawNumber + 1 > saveImageArray.count - 1 {return}
        
        self.canvasView.image = saveImageArray[currentDrawNumber + 1]   //保存しているUndo前のimageに置き換える
        
        currentDrawNumber += 1
        
    }
    
    /**
     Saveボタンを押した時の動作
     お絵描きをカメラロールへ保存する
     */
    @IBAction func pressSaveButton(_ sender: AnyObject) {
        
        UIImageWriteToSavedPhotosAlbum(self.canvasView.image!, self, nil, nil)  //カメラロールへの保存
        //self.performSegue(withIdentifier: "toMain", sender: self)
        
        dataDictionary["points"] = pointDic
        setLineDic()
        dataDictionary["labels"] = [:]
        dataDictionary["angles"] = [:]
        
        print("result: \(dataDictionary)")
        
        saveToPlistWithArray(dic: dataDictionary as NSDictionary)
    
        currentDrawNumber += 1
        
        performSegue(withIdentifier: "toMainView", sender: nil)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMainView") {
            
            let mainView = segue.destination as! ViewController
            mainView.figureDictionary = self.dataDictionary
        }
        
    }
    
    func setLineDic() {
        var lineDic = [String:Any]()
        var posDic = [String:Any]()
        
    
        var keys : Array = Array(pointDic.keys)
        keys.sort { $0 < $1 }
        
        
        
        
        var idx = 1
        var posname = ""
        var isEven = false
        var beginKey = ""
        
        for key in keys {
            if idx % 2 != 0 {
                posname = "begin"
                isEven = false
                beginKey = key
                
            } else {
                posname = "end"
                isEven = true
            }
            
            posDic[posname] = key
            
            if isEven {
                lineDic["\(beginKey)\(key)"] = posDic
            }
            idx += 1
        }
        dataDictionary["lines"] = lineDic
    }
    
        @IBAction func toMainButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveToPlistWithArray(dic: NSDictionary) {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
       // let path = directory.appendingPathComponent("data.plist")
        let filepath = directory.appending("/\(getCurrentDate()).plist")
        let success = dic.write(toFile: filepath, atomically: false)
        
        if success {
            print("save plist success!!")
        } else {
            print("save plist failed")
        }
    }
    
    func getCurrentDate() -> String {
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HHmmss"
        return  formatter.string(from: now as Date)
        
    }
 
}
