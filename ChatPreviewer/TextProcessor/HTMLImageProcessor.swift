//
//  HTMLImageProcessor.swift
//  ChatPreviewer
//
//  Created by Ahmed Essam on 3/26/16.
//  Copyright © 2016 Ahmed Essam. All rights reserved.
//

import Foundation

class HTMLImageProcessor: TextProcessorExtension {
    func definePattern() -> String{
        return "<meta property=[\"']og:image[\"'] content=[\"'](.+?)[\"'](.+?)>"
    }
    func matchFound(fonudText :String) -> AnyObject?{
        // This one is a big tricky, sometimes single quote is used sometimes double
        // qoute is used, so what I did to get the value of "content", is to split
        // from content= and take the second part, then split by double quote, if it
        // worked then fine and take teh value in second item, if not split by single
        // quote and get the seocnd time because values will be 'value', when split it
        // will be ["","value", ""]
        var parts = fonudText.componentsSeparatedByString("content=")
        if parts.count>=2 {
           parts = parts[1].componentsSeparatedByString("\"")
            if parts.count==1{
                parts = parts[0].componentsSeparatedByString("'")
            }
            if parts.count>=2{
                return parts[1]
            }
        }
        return ""
    }
    func processorName() -> String{
        return "image"
    }
}
