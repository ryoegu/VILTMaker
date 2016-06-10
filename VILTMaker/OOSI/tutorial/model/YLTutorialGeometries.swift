//
//  YLFooGeometries.swift
//  Textbook
//
//  Created by Hiloki OE on 10/27/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation
import C4

public class YLTutorialGeometries: CustomStringConvertible {
    let POINTTOLERANCE: Double = 5
    //let LINETOLERANCE: COFloat = 6
    let ANGLETOLERANCE: Double = 5
    
    let pointP: YLDot
    let pointQ: YLDot
    let points: [String: YLDot]
    
    let linePQ: YLLine
    let lines: [String: YLLine]
    
    let pieA: YLWedge
    let pieB: YLWedge
    
    public init(dots: [String: YLDot], lines: [String: YLLine], pieA: YLWedge, pieB: YLWedge) {
        print("debug: init \(pieA)")
        var ps = dots
      
        pointP = dots["P"]!
        pointQ = dots["Q"]!
        ps.removeValueForKey("P")
        ps.removeValueForKey("Q")
        points = ps

        self.linePQ = lines["PQ"]!
        var ls = lines
        ls.removeValueForKey("PQ")
        self.lines = ls
        
        self.pieA = pieA
        self.pieB = pieB
    }
    
    public func toScreenViews(converter: YLCoordinateConverter) -> [String: View] {
        var dic = [String: View]()
        dic["PQ"] = linePQ.toScreenHorizontalLine(40, converter: converter)
        for line in lines.values {
            let (p1, p2) = line.endPoints
            if (p2 - p1).x == 0 {
                dic[line.name] = line.toScreenVerticalLine(25, converter: converter)
            } else {
                dic[line.name] = line.toScreenHorizontalLine(25, converter: converter)
            }
        }
        dic[pieA.name] = pieA.toScreenView(converter)
        dic[pieB.name] = pieB.toScreenView(converter)
        return dic
    }
    
    public var description: String {
        let ds = points.values.reduce("\(pointP)\n\(pointQ)") { s, p in
            "\(s)\n\(p)"
        }
        let ls = lines.values.reduce("\(linePQ)") { s, l in
            "\(s)\n\(l)"
        }
        let ps = "\(pieA)\n\(pieB)"
        return "\(ds)\n\(ls)\n\(ps)"
    }
}