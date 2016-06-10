//
//
//  YLCongruenceView.swift
//  Textbook
//
//  Created by Hiloki OE on 7/5/15.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation
import C4

public class YLTutorialConfigParser {
    
    public class func parsePropertyList(plist: NSDictionary) -> YLTutorialGeometries {
        func toFloatPair(arr: NSArray) -> (Double, Double) {
            let x = arr[0] as! Double
            let y = arr[1] as! Double
            return (x, y)
        }
        func toPoint(xy: (Double, Double)) -> Point {
            return Point(xy.0 * 10 + 50, xy.1 * 10 + 50)
        }
        var ps = [String: Point]()
        for (k, v) in plist["points"] as! NSDictionary {
            let name = k as! String
            let arr = v as! NSArray
            ps[name] = toPoint(toFloatPair(arr))
        }
        
        var dots = [String: YLDot]()
        for (name, point) in ps {
            dots[name] = YLDot(name: name, center: point, dic: NSDictionary())
        }
        
        var ls = [String: YLLine]()
        for obj in plist["lines"] as! NSArray {
            let name = obj as! String
            var idx = name.startIndex
            let point1 = ps["\(name[idx])"]!
            idx = idx.successor();
            let point2 = ps["\(name[idx])"]!
            ls[name] = YLLine(name: name, begin: point1, end: point2, dic: NSDictionary())
        }
        
        let createWedge = { (name: String) -> YLWedge in
            let array = plist[name] as! NSArray
            return YLWedge(name: name, array: array, pointDictionary: ps, dic: NSDictionary())
        }
        let pie1 = createWedge("angle1")
        let pie2 = createWedge("angle2")
        
        let geometry =  YLTutorialGeometries(
            dots: dots, lines: ls, pieA: pie1, pieB: pie2)
        print(pie1)
        print("Geomtry parsed: \(geometry)")
        return geometry
    }
}