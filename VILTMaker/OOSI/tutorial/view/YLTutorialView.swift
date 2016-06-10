//
//
//  YLCongruenceView.swift
//  Textbook
//
//  Created by Hiloki OE on 12/8/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation
import UIKit
import C4

class YLTutorialView: View {
    var lineL: Polygon!
    var otherLines: [Polygon]!
    var pies: [Wedge]!
  
    private var tempCircle: Circle?
    
    override init() {
        super.init()
        self.backgroundColor = black
    }
    
    func addViews(lineL: View, otherLines: [View], pies: [View]) {
        self.lineL = lineL as! Polygon
        self.lineL.fillColor = C4Pink
        
        self.otherLines = otherLines.map { v in
            let l = v as! Polygon
            l.lineWidth = 0
            l.fillColor = yellow
            return l
        }
        
        self.pies = pies.map { v in
            let w = v as! Wedge
            w.fillColor = clear
            w.lineWidth = 15
            w.strokeColor = magenta
            return w
        }
        
        let views: [View] = [self.lineL] +
            self.otherLines.map{(l: Polygon) -> View in l } +
            self.pies.map{ (w: Wedge) -> View in w }
        for v in views {
            add(v)
        }
    }
    
    func addCircle(circle: Circle) {
        if let _ = tempCircle {
            remove(tempCircle)
        }
        tempCircle = circle
    }
    func removeCircle() {
        add(tempCircle)
        tempCircle = nil
    }
    
    override var description: String {
        let ls = otherLines.reduce("foo\(lineL)") { s, l in
            "\(s)\n\(l)"
        }
        let ps = pies.reduce("") { s, p in
            "\(s)\n\(p)"
        }
        return "\(ls)\n\(ps)"
    }
}