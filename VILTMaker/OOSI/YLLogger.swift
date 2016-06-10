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
    let date0: NSDate
    var log: [(NSTimeInterval, Double, Double)]
    init() {
        date0 = NSDate()
        log = []
    }
    
    func record(date: NSDate, point: Point) {
        let diff = date.timeIntervalSinceDate(date0)
        log.append(diff, point.x, point.y)
    }
    
    func save(filename: String) {
        let docDir = NSURL(fileURLWithPath: "\(NSHomeDirectory())/Documents/")
        let path = "\(docDir.path!)/\(filename)"
 
        var s = ""
        for (date, x, y) in log {
            let s1 = NSString(format: "%.3f, %.1f, %.1f\n", date, x, y) as String
            s += s1
        }
        do {
            try s.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
        print(path)
        print(s)
    }
    
    func getName() -> String {
        let format = NSDateFormatter()
        format.dateFormat = "yyyyMMdd_HHmmss"
        return format.stringFromDate(date0) + ".csv"
    }
}