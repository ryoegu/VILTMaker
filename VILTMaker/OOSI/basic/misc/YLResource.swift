//
//  YLResource.swift
//  Textbook
//
//  Created by Hiloki OE on 10/11/14.
//  Copyright (c) 2014 sophia univ. All rights reserved.
//

import Foundation

open class YLResource {
    open class func loadPropertyList(_ url: String) -> NSDictionary {
        let xmlData = try! Data(contentsOf: URL(string: url)!)
        return (try! PropertyListSerialization.propertyList(
            from: xmlData,
            options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves,
            format: nil)) as! NSDictionary
    }

    open class func loadBundleResource(_ name: String) -> NSDictionary {
        let path = Bundle.main.path(forResource: name, ofType: "plist")
        return NSDictionary(contentsOfFile: path!)!
    }

    open class func getURL(_ name: String, type: String) -> URL {
        return Bundle.main.url(forResource: name, withExtension: type)!
    }

    open class func loadBundleResource(_ name: String, type: String) -> Data {
        let url = getURL(name, type: type)
        return (try! Data(contentsOf: url))
    }
    
    open class func removeAllFiles(_ dir: URL) {
        let fileManager = FileManager.default
        for file in getDirectoryContents(dir) {
            do {
                try fileManager.removeItem(atPath: file.path)
            } catch _ {
            }
        }
    }
 
    open class func getDocDirURL() -> URL {
        let docDir = "\(NSHomeDirectory())/Documents/"
        return URL(fileURLWithPath: docDir)
    }

    open class func getDirectoryContents(_ dir: URL) -> [URL] {
        let props = NSArray(objects: URLResourceKey.localizedNameKey,
            URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey)
        let fileManager = FileManager.default
        let array = try! fileManager.contentsOfDirectory(
            at: dir,
            includingPropertiesForKeys: Array(props.map {$0 as! String}),
            options: ([.skipsPackageDescendants, .skipsHiddenFiles]))
        return array
        
    }
}
