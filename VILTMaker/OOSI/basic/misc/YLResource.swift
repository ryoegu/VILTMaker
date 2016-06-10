//
//  YLResource.swift
//  Textbook
//
//  Created by Hiloki OE on 10/11/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation

public class YLResource {
    public class func loadPropertyList(url: String) -> NSDictionary {
        let xmlData = NSData(contentsOfURL: NSURL(string: url)!)!
        return (try! NSPropertyListSerialization.propertyListWithData(
            xmlData,
            options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves,
            format: nil)) as! NSDictionary
    }

    public class func loadBundleResource(name: String) -> NSDictionary {
        let path = NSBundle.mainBundle().pathForResource(name, ofType: "plist")
        return NSDictionary(contentsOfFile: path!)!
    }

    public class func getURL(name: String, type: String) -> NSURL {
        return NSBundle.mainBundle().URLForResource(name, withExtension: type)!
    }

    public class func loadBundleResource(name: String, type: String) -> NSData {
        let url = getURL(name, type: type)
        return NSData(contentsOfURL: url)!
    }
    
    public class func removeAllFiles(dir: NSURL) {
        let fileManager = NSFileManager.defaultManager()
        for file in getDirectoryContents(dir) {
            do {
                try fileManager.removeItemAtPath(file.path!)
            } catch _ {
            }
        }
    }
 
    public class func getDocDirURL() -> NSURL {
        let docDir = "\(NSHomeDirectory())/Documents/"
        return NSURL(fileURLWithPath: docDir)
    }

    public class func getDirectoryContents(dir: NSURL) -> [NSURL] {
        let props = NSArray(objects: NSURLLocalizedNameKey,
            NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey)
        let fileManager = NSFileManager.defaultManager()
        let array = try! fileManager.contentsOfDirectoryAtURL(
            dir,
            includingPropertiesForKeys: Array(props.map {$0 as! String}),
            options: ([.SkipsPackageDescendants, .SkipsHiddenFiles]))
        return array
        
    }
}