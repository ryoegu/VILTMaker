//
//  YLPie.swift
//  Textbook
//
//  Created by 木村藍妃 on 2015/01/04.
//  Copyright (c) 2015年 sophia univ. All rights reserved.
//

import Foundation
import C4

open class YLWedge: Wedge {
    let name: String
    let radius: Double
    let start: Double
    let end: Double
    let options: NSDictionary
    public init(name: String, center: Point, start: Double, end: Double, radius: Double = 12, options: NSDictionary = NSDictionary()) {
        self.name = name
        self.radius = radius
        self.start = start
        self.end = end
        self.options = options
        super.init(center: center, radius: radius, start: start, end: end, clockwise: true)
        fillColor = C4Blue
        strokeColor = C4Purple
    }
    
    open override var description: String {
        return "\(name): \(center), (\(start) -> \(end)), \(radius)"
        
    }
}
