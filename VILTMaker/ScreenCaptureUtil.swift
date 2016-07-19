//
//  ScreenCaptureUtil.swift
//  VILTMaker
//
//  Created by Ryo Eguchi on 2016/07/20.
//  Copyright © 2016年 Ryo Eguchi. All rights reserved.
//

import UIKit

struct ScreenCaptureUtil {
    static func take(view: UIView)->UIImage{
        
        let layer = view.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return screenshot;
        
    }
}