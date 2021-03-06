//
//  YLDot.swift
//  c4-text
//
//  Created by Phil Owen on 5/24/16.
//  Copyright © 2016 Phil Owen. All rights reserved.
//

import Foundation
import C4

class YLCircle: Circle {
    internal let name: String
    internal let radius: Double
    internal let options: NSDictionary
    
    public init(name: String, center: Point, radius: Double = 0, options: NSDictionary = NSDictionary()) {
        self.name = name
        self.radius = radius
        self.options = options
        let frame = Rect(center.x-radius, center.y-radius, radius * 2, radius * 2)
        super.init(frame: frame)
        strokeColor = nil
        fillColor = green
    }

    public convenience init(name: String, props: NSDictionary) {
        let x = props["x"] as! Double
        let y = props["y"] as! Double
        let p = Point(x, y)
        self.init(name: name, center: p)
    }

    public required init(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    open override var description: String {
        return "\(name): (\(center), \(radius))"
    }
}
