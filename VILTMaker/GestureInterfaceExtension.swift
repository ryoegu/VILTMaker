//
//  GestureInterfaceExtension.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/12/05.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//


import Foundation
import UIKit
import C4

extension ViewController {
    
    func trackpadInterfaceInit() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipe(_:)))
        rightSwipe.direction = .right
        self.gestureInterface.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipe(_:)))
        leftSwipe.direction = .left
        self.gestureInterface.addGestureRecognizer(leftSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upSwipe(_:)))
        upSwipe.direction = .up
        self.gestureInterface.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(downSwipe(_:)))
        downSwipe.direction = .down
        self.gestureInterface.addGestureRecognizer(downSwipe)
        
    }
    
    func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        print("RIGHT")
    }
    
    func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        print("LEFT")
    }
    
    func upSwipe(_ sender: UISwipeGestureRecognizer) {
        print("UP")
        
    }
    
    func downSwipe(_ sender: UISwipeGestureRecognizer) {
        print("DOWN")
    }
    
    
    
}
