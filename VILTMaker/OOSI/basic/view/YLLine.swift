//
//  YLLineSegment.swift
//  Textbook
//
//  Created by Hiloki OE on 11/18/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation
import C4

public class YLLine: Line {
    let name: String
    let options: NSDictionary
    public init(name: String, begin: Point, end: Point, options: NSDictionary = NSDictionary()) {
        self.name = name
        self.options = options
        super.init([begin, end])
        lineWidth = 5
    }

    public required init(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    public func buffer(b: Double = 4) -> Polygon {
        let (p1, p2) = endPoints
        return YLPolygon(name: name, begin: p1, end: p2, buffer: b)
    }
    
    public override var description: String {
        let (p1, p2) = endPoints
        return "\(name): \(p1) -> \(p2) "
    }
}
