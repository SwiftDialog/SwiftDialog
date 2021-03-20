//
//  Processing.swift
//  dialog
//
//  Created by Bart Reardon on 10/3/21.
//

import Foundation
import AppKit
import SystemConfiguration
import SwiftUI


func getImageFromPath(fileImagePath: String, imgWidth: CGFloat? = .infinity, imgHeight: CGFloat? = .infinity) -> NSImage {
    // accept image as local file path or as URL and return NSImage
    // can pass in width and height as optional values otherwsie return the image as is.
    
    // origional implementation lifted from Nudge and modified
    // https://github.com/macadmins/nudge/blob/main/Nudge/Utilities/Utils.swift#L46
    
    // need to declare literal empty string first otherwsie the runtime whinges about an NSURL instance with an empty URL string. I know!
    var urlPath = NSURL(string: "")!
    
    // checking for anything starting with http - crude but it works (for now)
    if fileImagePath.hasPrefix("http") {
        urlPath = NSURL(string: fileImagePath)!
    } else {
        urlPath = NSURL(fileURLWithPath: fileImagePath)
    }
    var imageData = NSData()
    
    // wrap everything in a try block.IF the URL or filepath is unreadable then return a default wtf image
    do {
        imageData = try NSData(contentsOf: urlPath as URL)
    } catch {
        let errorImageConfig = NSImage.SymbolConfiguration(pointSize: 200, weight: .ultraLight)
        return NSImage(systemSymbolName: "questionmark.square,dashed", accessibilityDescription: nil)!.withSymbolConfiguration(errorImageConfig)!
    }
    
    let image : NSImage = NSImage(data: imageData as Data)!
    if let rep = NSImage(data: imageData as Data)!
        .bestRepresentation(for: NSRect(x: 0, y: 0, width: imgWidth!, height: imgHeight!), context: nil, hints: nil) {
        image.size = rep.size
        image.addRepresentation(rep)
    }
    return image
}

func openSpecifiedURL(urlToOpen: String) {
    // Open the selected URL (no checking is perfoemrd)
    
    if let url = URL(string: urlToOpen) {
        NSWorkspace.shared.open(url)
    }
}

func getAppIcon(appPath : String, withSize : CGFloat) -> NSImage {
    // take application path and extracts the application icon and returns is as NSImage
    // Swift implimentation of the ObjC code used in SAP's nice "Icons" utility for extracting application icons
    // https://github.com/SAP/macOS-icon-generator/blob/master/source/Icons/MTDragDropView.m#L66
    
    let image = NSImage()
    if let rep = NSWorkspace.shared.icon(forFile: appPath)
        .bestRepresentation(for: NSRect(x: 0, y: 0, width: withSize, height: withSize), context: nil, hints: nil) {
        image.size = rep.size
        image.addRepresentation(rep)
    }
    return image
}

func printVersionString() -> Void {
    //what it says on the tin
    print(getVersionString())
}

func getVersionString() -> String {
    var appVersion: String = "0.0"
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        appVersion = version
    }
    return appVersion
}
