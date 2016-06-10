//
//  YLLengthRatioStatus.swift
//  Textbook
//
//  Created by 木村藍妃 on 2014/12/20.
//  Copyright (c) 2014年 sophia univ. All rights reserved.
//

import Foundation

public enum YLTopology {
    case OnPoint(String)
    case OnLine(String, Double)
    case OnPie(String)
    case Void
    
    public var description: String {
        get {
            switch self {
            case .OnPoint(let name):
                return "Point \(name)"
  
            case .OnPie(let name):
                return "Pie \(name)"
                
            case .OnLine(let name, let dist):
                return "Line \(name): dist = \(dist)"
                
            case .Void:
                return "Void"
            }
        }
    }
    
    public var isOnPoint: Bool {
        get {
            switch self {
            case .OnPoint(_):
                return true
            default:
                return false
            }
        }
    }

    public var isOnLine: Bool {
        get {
            switch self {
            case .OnLine(_):
                return true
            default:
                return false
            }
        }
    }
}

public func == (left: YLTopology, right: YLTopology) -> Bool {
    switch (left, right) {
    case let (.OnPoint(name1), .OnPoint(name2)):
        return name1 == name2
        
    case let (.OnLine(name1, dist1), .OnLine(name2, dist2)):
        return name1 == name2 && dist1 == dist2

    case let (.OnPie(name1), .OnPie(name2)):
        return name1 == name2
        
    case
        (.Void, .Void):
        return true
        
    default:
        return false
    }
}

public func != (left: YLTopology, right: YLTopology) -> Bool {
    return !(left == right)
}

