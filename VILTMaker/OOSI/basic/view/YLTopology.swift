//
//  YLLengthRatioStatus.swift
//  Textbook
//
//  Created by 木村藍妃 on 2014/12/20.
//  Copyright (c) 2014年 sophia univ. All rights reserved.
//

import Foundation

public enum YLTopology {
    case onPoint(String)
    case onLine(String, Double)
    case onPie(String)
    case void
    
    public var description: String {
        get {
            switch self {
            case .onPoint(let name):
                return "Point \(name)"
  
            case .onPie(let name):
                return "Pie \(name)"
                
            case .onLine(let name, let dist):
                return "Line \(name): dist = \(dist)"
                
            case .void:
                return "Void"
            }
        }
    }
    
    public var isOnPoint: Bool {
        get {
            switch self {
            case .onPoint(_):
                return true
            default:
                return false
            }
        }
    }

    public var isOnLine: Bool {
        get {
            switch self {
            case .onLine(_):
                return true
            default:
                return false
            }
        }
    }
}

public func == (left: YLTopology, right: YLTopology) -> Bool {
    switch (left, right) {
    case let (.onPoint(name1), .onPoint(name2)):
        return name1 == name2
        
    case let (.onLine(name1, dist1), .onLine(name2, dist2)):
        return name1 == name2 && dist1 == dist2

    case let (.onPie(name1), .onPie(name2)):
        return name1 == name2
        
    case
        (.void, .void):
        return true
        
    default:
        return false
    }
}

public func != (left: YLTopology, right: YLTopology) -> Bool {
    return !(left == right)
}

