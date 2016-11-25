//
//  YLLogger.swift
//  Textbook
//
//  Created by 木村藍妃 on 2014/12/14.
//  Copyright (c) 2014年 sophia univ. All rights reserved.
//

import Foundation
import C4

class YLLogger {
    let date0: Date
    var log: [(TimeInterval, Double, Double)]
    init() {
        date0 = Date()
        log = []
    }
    
    func record(_ date: Date, point: Point) {
        let diff = date.timeIntervalSince(date0)
        log.append(diff, point.x, point.y)
    }
    
    func save(_ filename: String) {
        let docDir = URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/")
        let path = "\(docDir.path)/\(filename)"
 
        var s = ""
        for (date, x, y) in log {
            let s1 = NSString(format: "%.3f, %.1f, %.1f\n", date, x, y) as String
            s += s1
        }
        do {
            try s.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
        print(path)
        print(s)
    }
    
    func getName() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd_HHmmss"
        return format.string(from: date0) + ".csv"
    }
}
