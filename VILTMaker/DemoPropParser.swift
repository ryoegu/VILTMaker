//
//  DemoPropParser.swift
//  c4-text
//
//  Created by Phil Owen on 5/26/16.
//  Copyright © 2016 Phil Owen. All rights reserved.
//

import Foundation
import C4

func conv(p: Point) -> Point {
//    let x = map(p.x, min: -384, max: 384, toMin: 0, toMax: 768)
//    let y = map(p.y, min: 367.5, max: -367.5, toMin: 0, toMax: 735)
    return Point(p.x, p.y)
}

class DemoPropParser {
    let props: NSDictionary
    private var points = [String: Point]()

    init(_ props: NSDictionary) {
        self.props = props
        for (name, pointProps) in props["points"] as! NSDictionary {
            let k = name as! String
            let p = createPoint(pointProps as! NSDictionary)
            points[k] = p
        }
    }
    
    func createPoint(props: NSDictionary) -> Point {
        let x = props["x"] as! Double
        let y = props["y"] as! Double
        return Point(x, y)
    }
    
    func getPoints() -> [String: Point] {
        return points
    }
    
    func getCircles() -> [String: Circle] {
        var circles = [String: Circle]()
        for (k, pointProps) in props["points"] as! NSDictionary {
            let name = k as! String
            let p = conv(points[name]!)
            let c = YLCircle(name: name, center: p, options: pointProps as! NSDictionary)
            circles[name] = c
        }
        return circles
    }

    func getPolygons() -> [String: Polygon] {
        var lines = [String: Polygon]()
        for (k, v) in props["lines"] as! NSDictionary {
            let name = k as! String
            let props = v as! NSDictionary
            let (p1, p2) = (props["begin"] as! String, props["end"] as! String)
            let begin = conv(points[p1]!)
            let end = conv(points[p2]!)
            let line = YLLine(name: name, begin: begin, end: end)
            lines[name] = line.buffer()
        }
        return lines
    }
    
    func getLabels() -> [String: TextShape] {
        var labels = [String: TextShape]()
        for (k, v) in props["labels"] as! NSDictionary {
            let name = k as! String
            let props = v as! NSDictionary
            let p = conv(createPoint(props))
            let s = props["text"] as! String
            let label = YLTextShape.create(p, text: s, options: props)
            labels[name] = label
        }
        return labels
    }
    
    func getAngles() -> [String: Wedge] {
        var angles = [String: Wedge]()
        for (k, v) in props["angles"] as! NSDictionary {
            let name = k as! String
            let props = v as! NSDictionary
            let center = conv(points[props["center"] as! String]!)
            let start = conv(points[props["start"] as! String]!)
            let end = conv(points[props["end"] as! String]!)
            let a = (start - center).heading
            let b = (end - center).heading
            angles[name] = YLWedge(name: name, center: center, start: a, end: b)
        }
        return angles
    }
}