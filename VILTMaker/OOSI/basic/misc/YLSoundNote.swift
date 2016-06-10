//
//  YLSoundNote.swift
//  Textbook
//
//  Created by 木村藍妃 on 2015/01/04.
//  Copyright (c) 2015年 sophia univ. All rights reserved.
//

import Foundation

public enum YLSoundNote: Int {
    case C4, D4, E4, F4, G4, A4, B4, C5, D5, E5
    
    public var description: String {
        get {
            switch(self) {
            case .C4:
                return "C4"
            case .D4:
                return "D4"
            case .E4:
                return "E4"
            case .F4:
                return "F4"
            case .G4:
                return "G4"
            case .A4:
                return "A4"
            case .B4:
                return "B4"
                
            case .C5:
                return "C5"
            case .D5:
                return "D5"
            case .E5:
                return "E5"
            
            }
        }
    }
}
