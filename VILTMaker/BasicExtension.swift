//
//  BasicExtension.swift
//  NibViewSampler
//
//  Created by Ryo Eguchi on 2017/01/13.
//  Copyright © 2017年 Ryo Eguchi. All rights reserved.
//

import UIKit

extension UIApplication {
    var forwardViewController: UIViewController? {
        guard var forwardViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = forwardViewController.presentedViewController {
            forwardViewController = presentedViewController
        }
        return forwardViewController
    }
    var forwardNavigationController: UINavigationController? {
        return forwardViewController as? UINavigationController
    }
    
    
    
}
