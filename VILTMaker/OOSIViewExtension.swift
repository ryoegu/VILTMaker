//
//  OOSIViewExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/18.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//  Supported by Owen.
//

import Foundation
import UIKit
import C4

extension ViewController {

    // MARK: OOSI View
    func oosiViewInit() {
        
        oosiView.backgroundColor = black
        canvas.add(oosiView)
        speaker = YLSpeechSynthesizer()
        
        let myTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapGesture(sender:)))
        myTap.numberOfTapsRequired = 2
    }
    
    internal func tapGesture(sender: UITapGestureRecognizer){
        print("tapnumber == \(sender.numberOfTouches)")
    }
    
    func oosiViewResources(_ dictionary:Dictionary<String, Any> = [:]) {
        
        var parser: DemoPropParser!
        
        if dictionary.isEmpty {
            parser = DemoPropParser(YLResource.loadBundleResource(figureNumberString))
        }else{
            parser = DemoPropParser(dictionary as NSDictionary)
        }
        
        points = parser.getPoints()
        polygons = parser.getPolygons()
        sounds = SoundManager(YLResource.loadBundleResource("resources"))
    
        
        oosiView.addPanGestureRecognizer { locations, center, translation, velocity, state in
            self.onPanning(center)
        }
        
        //Double Tap Gesture Recognizer(レイヤー別インターフェースの実装)
        oosiView.addDoubleTapGestureRecognizer{_,_,_ in 
            print("DOUBLE TAPPED")
            
        }
        
        oosiView.addDoubleTapGestureRecognizer { (points, point, recognizer) in
            let c = Circle(center: point, radius: 30)
            self.oosiView.add(c)
            c.addTapGestureRecognizer { _, center, _ in
                print("Point:", center)
                self.sounds.pong()
                
                c.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: 1)
            }
            
        }
        
        addViews(Array(parser.getCircles().values),
                 Array(polygons.values),
                 Array(parser.getLabels().values),
                 Array(parser.getAngles().values))
    }
    
    
    
    func tappedDouble(sender: UITapGestureRecognizer!) {
        print("double tapped enabled...")
    }
    
    func addViews(_ circles: [Circle], _ polygons: [Polygon], _ labels: [TextShape], _ angles: [Wedge]) {
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
    
    func removeViews(_ circles: [Circle], _ polygons: [Polygon], _ labels: [TextShape], _ angles: [Wedge]) {
        for p in polygons {
            oosiView.remove(p)
        }
        for c in circles {
            oosiView.remove(c)
        }
        for a in angles {
            oosiView.remove(a)
        }
        for l in labels {
            oosiView.remove(l)
        }
    }
    
    func onPanning(_ center: Point) {
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

    
    func pip(_ distance: Double) {
        let note = YLSoundNote(rawValue: Int(distance)/80)!
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
