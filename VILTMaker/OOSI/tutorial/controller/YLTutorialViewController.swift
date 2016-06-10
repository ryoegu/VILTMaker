//
//  FooController.swift
//  Textbook
//
//  Created by 木村藍妃 on 2014/12/08.
//  Copyright (c) 2014年 sophia univ. All rights reserved.
//

import Foundation
import UIKit
import C4

class YLTutorialViewController: CanvasController {
    let mainView: YLTutorialView
    let log: YLLogger
    private var geoms: YLTutorialGeometries!
    private var views: [String: View]!
    private var sounds: YLTutorialSoundManager!
    private var converter: YLViewConverter!
    private var prevNotes: (YLSoundNote?, YLSoundNote?)
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        log = YLLogger()
        prevNotes = (nil, nil)
        mainView = YLTutorialView()
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        mainView.size = Size(canvas.width, canvas.width)
        mainView.center = Point(canvas.width/2, canvas.height - mainView.height/2)
        canvas.add(mainView)
        let params = YLResource.loadBundleResource("tutorial")
        converter = YLViewConverter(size: mainView.frame.size)
        geoms = YLTutorialConfigParser.parsePropertyList(params)
        views = geoms.toScreenViews(converter.converter)
        
        let res = YLResource.loadBundleResource("resources")
        sounds = YLTutorialSoundManager(plist: res)
        
        configureView(params)
        hookEvents()
    }
    
    private func configureView(params: NSDictionary) {
        for view in views.values {
            mainView.add(view)
        }
        for (k, v) in views {
            print(k, v)
        }
        mainView.addViews(views[geoms.linePQ.name]!,
                          otherLines: geoms.lines.map { name, _ in views[name]! },
                          pies: [geoms.pieA, geoms.pieB].map { pie in views[pie.name]! })
        print("Views added: \(mainView)")
        
        for label in converter.labelsWithPropertyList(params) {
            label.font = Font(name: "Arial", size: 50)!
            mainView.add(label)
        }
    }
    
    func hookEvents() {
        mainView.addPanGestureRecognizer { locations, _, _, _, state in
            self.onTouch(locations, state: state)
        }
        mainView.addTapGestureRecognizer { locations, _, state in
            self.onTouch(locations, state: state)
        }
        
        for w in mainView.pies {
            let tap = w.addTapGestureRecognizer { _ in
                self.sounds.sayYouAreOnPie()
            }
            tap.numberOfTapsRequired = 2
        }
    }
    
    func onTouch(locations: [Point], state: UIGestureRecognizerState) {
        switch state {
        case .Began, .Changed:
            if let p = locations.first,
               let s = self.findClosestLine(p) {
                if s.origin == mainView.lineL.origin {
                    onLineL(p)
                }
                let ls = geoms.lines.values
                if ls.contains( { l in l.origin == s.origin }) {
                    onRectEdges(p, shape: s)
                } else {
                    print("void")
                }
                
            }
        default:
            self.touchEnded()
            
        }
        let view = self.mainView
        if let p = locations.first {
            self.showLocation(p)
            if view.lineL.hitTest(p) {
                
            }
        }
        
    }
    
    func findClosestLine(position: Point) -> YLLine? {
        if (mainView.lineL.hitTest(position)) {
            return geoms.linePQ
        }
        for (i, l) in mainView.otherLines.enumerate() {
            if l.hitTest(position) {
                let lines = Array(geoms.lines.values)
                return lines[i]
            }
        }
        return nil
    }
    
    func onLineL(position: Point) {
        let p = converter.normalize(position)
        let q = mainView.lineL.points.first!
        let dist = Int(distance(p, rhs: q))
        let note = YLSoundNote(rawValue: dist/12)!
        if let prevNote = prevNotes.0 {
            if prevNote != note {
                sounds.stopAllSounds()
                sounds.pip(note)
            } else {
                print("same: \(prevNotes)")
            }
        } else {
            sounds.pip(note)
        }
        prevNotes = (note, nil)
    }
    
    func onRectEdges(position: Point, shape: YLLine) {
        let p = converter.normalize(position)
        let q = mainView.lineL.points.first!
        let dist = Int(distance(p, rhs: q))
        let note = YLSoundNote(rawValue: dist/10)!
        if let prevNote = prevNotes.1 {
            if prevNote != note {
                sounds.stopAllSounds()
                sounds.pip(note)
            } else {
                print("same: \(prevNotes)")
            }
        } else {
            sounds.pip(note)
        }
        prevNotes = (nil, note)
    }
    
    func touchEnded() {
        prevNotes = (nil, nil)
    }
    
    private func onTouchedLine(distance: Double) {
        let note = YLSoundNote(rawValue: Int(Double(distance)) / 11)!
        if let prevNote = prevNotes.0 {
            if prevNote != note {
                sounds.stopAllSounds()
                sounds.pip(note)
            } else {
                print("same: \(prevNotes)")
            }
        } else {
            sounds.pip(note)
        }
        showStatus("note: \(note.description)")
        prevNotes = (note, nil)
    }
    
    private func onTouchedLineEdge(p: Point) {
        sounds.pong()
        prevNotes = (nil, nil)
    }
    
    private func showLocation(p: Point) {
        let s = NSString(format: "%.1f, %.1f", p.x, p.y) as String
        positionLabel.text = s
        //print("DEBUG: touched point-\(s)")
        log.record(NSDate(), point: p)
    }
    
    private func showStatus(s: String) {
        statusLabel.text = s
        print(s)
    }
}
