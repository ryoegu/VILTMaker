//
//  ConstColor.swift
//  o2
//
//  Created by Ryo Eguchi on 2015/08/29.
//  Copyright (c) 2015年 Ryo Eguchi. All rights reserved.
//

import Foundation

class ConstColor {
    
    class var main: UIColor {
        return UIColor(rgba: "#FD8B25")
    }
    
    class var naviation: UIColor {
        return UIColor(rgba: "#071019")
    }
    
    class var tab: UIColor {
        return UIColor(rgba: "#2A1B0A")
    }
    
    //MARK: User Color
    class var yellowString: String {
        return "#F8BF2C"
    }
    class var yellow: UIColor {
        return UIColor(rgba: yellowString)
    }

    class var greenString: String {
        return "#71D857"
    }
    class var green: UIColor {
        return UIColor(rgba:greenString)
    }
    
    class var lightBlueString: String {
        return "#66BEE8"
    }
    class var lightBlue: UIColor {
        return UIColor(rgba: lightBlueString)
    }
    
    class var purpleString: String{
        return "#C489E8"
    }
    class var purple: UIColor {
        return UIColor(rgba: purpleString)
    }
    
    class var pinkString: String {
        return "#FA9EE4"
    }
    class var pink: UIColor {
        return UIColor(rgba:pinkString)
    }
    class var whiteString: String {
        return "#FFFFFF"
    }
    class var white: UIColor {
        return UIColor(rgba:whiteString)
    }
    
}
