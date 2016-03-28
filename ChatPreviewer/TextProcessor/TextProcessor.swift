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
        // To save couple of lines of code, this static funciton creats
        // Process with all possible processors supported.
        let tp = TextProcessor()
        tp.addTextPattern(MentionsProcessor())
        tp.addTextPattern(HashtagsProcessor())
        tp.addTextPattern(EmoticonProcessor())
        tp.addTextPattern(URLProcessor())
        return tp
    }
    
    // The funciton looks through the processors and send creates regular
    // expression object and send the result back to the processor for 
    // post matching processing.
    // Then it collects all the results groupped by the processor provided name
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
            
            // Removing dublicates by converting the array into set then back
            // to array again.
            if let foundItems = foundEntities[processor.0] as? Array<String>{
                let foundItemsAsSet = Set<String>(foundItems)
                foundEntities[processor.0] = Array<String>(foundItemsAsSet)
            }
        }
        return foundEntities
    }
    
    // This is similar to the Observer pattern except it uses a dictionary 
    // and the observer should provide the name as a key in the dictionary
    // this is part of the design, as it will help in the text processing 
    // grouping result will be based on that key.
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
