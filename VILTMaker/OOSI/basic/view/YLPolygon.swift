//
//  YLPolygon.swift
//  c4-text
//
//  Created by Phil Owen on 5/24/16.
//  Copyright © 2016 Phil Owen. All rights reserved.
//

import Foundation
import C4

public class YLPolygon: Polygon {
    let name: String
    let options: NSDictionary
    public convenience init(name: String, begin: Point, end: Point, buffer: Double = 5) {
        let v1 = Vector(x: begin.x, y: begin.y)
        let v2 = Vector(x: end.x, y: end.y)
        let direction = (v2-v1).unitVector()!
        let normal = Vector(x: -direction.y, y: direction.x)
        let p1 = v1 + buffer * normal
        let p2 = v1 - buffer * normal
        let p3 = v2 - buffer * normal
        let p4 = v2 + buffer * normal
        let points = [p1, p2, p3, p4].map { v in Point(v.x, v.y) }
        self.init(name: name, points: points)
        close()
        strokeColor = nil
        fillColor = yellow
    }
    
    public init(name: String, points: [Point], options: NSDictionary = NSDictionary()) {
        self.name = name
        self.options = options
        super.init(points)
    }
    
    public required init(coder: NSCoder) {
        fatalError("not implemented")
    }

    public override var description: String {
        return points.reduce("\(name): ") { s, p in "\(s) \(p)" }
    }
}
