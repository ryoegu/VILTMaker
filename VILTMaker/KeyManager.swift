//
//  KeyManager.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/05/27.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//
//  THIS FILE IS OPEN-SOURCE.BUT A PIECE OF FUNCTION NEEDS TO USE API KEY.
//  IF YOU WANT MORE INFORMATION, PLEASE CHECK OUT README FILE.

import Foundation

struct KeyManager {
    
    fileprivate let keyFilePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    
    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }
    
    func getValue(_ key: String) -> Any? {
        guard let keys = getKeys() else {
            return nil
        }
        return keys[key]
    }
    
}
