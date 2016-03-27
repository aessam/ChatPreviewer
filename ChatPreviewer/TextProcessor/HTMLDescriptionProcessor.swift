//
//  HTMLDescriptionProcessor.swift
//  ChatPreviewer
//
//  Created by Ahmed Essam on 3/26/16.
//  Copyright © 2016 Ahmed Essam. All rights reserved.
//

import Foundation

class HTMLDescriptionProcessor: TextProcessorExtension {
    func definePattern() -> String{
        return "<meta property=[\"']og:description[\"'] content=[\"'](.+?)[\"'](.+?)>"
    }
    func matchFound(fonudText :String) -> AnyObject?{
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
        return "description"
    }

}
