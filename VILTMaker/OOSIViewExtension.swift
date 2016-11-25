//
//  OOSIViewExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/18.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
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

    }
    
    func oosiViewResources() {
        let parser = DemoPropParser(YLResource.loadBundleResource(figureNumberString))
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
