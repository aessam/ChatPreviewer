//
//  TextProcessor.swift
//  ChatPreviewer
//
//  Created by Ahmed Essam on 3/26/16.
//  Copyright © 2016 Ahmed Essam. All rights reserved.
//

import Foundation


protocol TextProcessorExtension {
    func definePattern() -> String
    func matchFound(fonudText :String) -> AnyObject?
    func processorName() -> String
}

public class TextProcessor: NSObject {
    
    var processors : [String: TextProcessorExtension] = [:]
    var patterns : [String: NSRegularExpression]=[:]
    
    public static func createFullProcessor()->TextProcessor{
        let tp = TextProcessor()
        tp.addTextPattern(MentionsProcessor())
        tp.addTextPattern(HashtagsProcessor())
        tp.addTextPattern(EmoticonProcessor())
        tp.addTextPattern(URLProcessor())
        return tp
    }
    
    func processText(text:String) -> Dictionary<String, Array<AnyObject>> {
        var foundEntities = [String: Array<AnyObject>]()
        for processor in processors {
            patterns[processor.0]?.enumerateMatchesInString(text, options: .ReportCompletion , range: NSMakeRange(0, text.characters.count),usingBlock: { (result, flags, _) in
                if let range = result?.range{
                    let nsText = text as NSString
                    let result = processor.1.matchFound(nsText.substringWithRange(range))
                    if foundEntities[processor.0]==nil{
                        foundEntities[processor.0] = Array<AnyObject>()
                    }
                    if let validResult = result{
                        foundEntities[processor.0]?.append(validResult)
                    }
                }
            })
        }
        return foundEntities
    }
    
    func addTextPattern(textProcessor: TextProcessorExtension){
        
        processors[textProcessor.processorName()] = textProcessor
        
        var expression : NSRegularExpression?

        do {
            expression = try NSRegularExpression(pattern: textProcessor.definePattern(), options: .CaseInsensitive)
        } catch _ {
            expression = nil
        }

        if let validExpression = expression {
            patterns[textProcessor.processorName()] = validExpression
        }

    }
    
}
