//
//  YLTextShape.swift
//  c4textbook
//
//  Created by Phil Owen on 5/28/16.
//  Copyright © 2016 Phil Owen. All rights reserved.
//

import Foundation
import C4

// TextShapeは子がアクセス可能なイニシャライザがないので、
// イニシャライザを定義できず、事実上継承できないらしい。
public class YLTextShape {
    class func create(center: Point, text: String, options: NSDictionary = NSDictionary()) -> TextShape {
        let size = (options["size"] != nil) ? (options["size"] as! Double) : 10
        let f = Font(name: "Hiragino Kaku Gothic ProN", size: size)!
        let text = TextShape(text: text, font: f)!
        text.center = center
        text.fillColor = white
        return text
    }
}

extension TextShape {
    public override var description: String {
        return "\(text)@\(center)"
    }
}
