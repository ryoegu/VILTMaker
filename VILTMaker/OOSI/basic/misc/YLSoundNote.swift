//
//  YLSoundNote.swift
//  Textbook
//
//  Created by 木村藍妃 on 2015/01/04.
//  Copyright (c) 2015年 sophia univ. All rights reserved.
//

import Foundation

public enum YLSoundNote: Int {
    case c4, d4, e4, f4, g4, a4, b4, c5, d5, e5
    
    public var description: String {
        get {
            switch(self) {
            case .c4:
                return "C4"
            case .d4:
                return "D4"
            case .e4:
                return "E4"
            case .f4:
                return "F4"
            case .g4:
                return "G4"
            case .a4:
                return "A4"
            case .b4:
                return "B4"
                
            case .c5:
                return "C5"
            case .d5:
                return "D5"
            case .e5:
                return "E5"
            
            }
        }
    }
}
