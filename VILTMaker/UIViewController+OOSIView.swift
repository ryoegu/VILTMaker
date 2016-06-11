//
//  OOSIView.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/06/10.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit
import C4



class OOSIView: View {
    
    var sounds: SoundManager!
    var speaker: YLSpeechSynthesizer!
    var points = [String: Point]()
    var polygons = [String: Polygon]()
    var prevNote: YLSoundNote? = nil
    
    override init() {
        canvas.backgroundColor = black
        speaker = YLSpeechSynthesizer()
        let parser = DemoPropParser(YLResource.loadBundleResource("Demo"))
        points = parser.getPoints()
        polygons = parser.getPolygons()
        sounds = SoundManager(YLResource.loadBundleResource("resources"))
        
        canvas.addPanGestureRecognizer { _, center, _, _, _ in
            self.onPanning(center)
        }
        
        let k = canvas.width/100
        canvas.transform = Transform.makeScale(k, k)
        
        addViews(Array(parser.getCircles().values),
                 Array(polygons.values),
                 Array(parser.getLabels().values),
                 Array(parser.getAngles().values))
    }

    
    func addViews(circles: [Circle], _ polygons: [Polygon], _ labels: [TextShape], _ angles: [Wedge]) {
        for p in polygons {
            canvas.add(p)
        }
        for c in circles {
            canvas.add(c)
            c.addTapGestureRecognizer { _, center, _ in
                print("Point:", center)
                sounds.pong()
                c.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: 1)
            }
        }
        for a in angles {
            canvas.add(a)
        }
        for l in labels {
            canvas.add(l)
            l.addTapGestureRecognizer { _ in
                speaker.speak(l.text)
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
