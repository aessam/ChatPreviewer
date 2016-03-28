//
//  EmoticonProcessor.swift
//  ChatPreviewer
//
//  Created by Ahmed Essam on 3/26/16.
//  Copyright © 2016 Ahmed Essam. All rights reserved.

//
// The way it works by defining certain set of emoticons and concatinate
// it, so the regular expression looks for ( x | y | z ), it is like
// big array of ors, this to avoid unsupported text like (shongabewzas)
// which has no emoticon or doesn't mean anything.

import Foundation

class EmoticonProcessor: TextProcessorExtension {
    func definePattern() -> String{
        let emos = ["allthethings", "android", "areyoukiddingme",
                    "arrington", "arya", "ashton", "atlassian",
                    "awesome", "awthanks", "aww", "awwyiss",
                    "awyeah", "badass", "badjokeeel", "badpokerface",
                    "badtime", "bamboo", "basket", "beer",
                    "bicepleft", "bicepright", "megusta", "coffee", "success"]
        
        return "\\((" + emos.joinWithSeparator("|") + ")?\\)"
    }
    func matchFound(fonudText :String) -> AnyObject?{
        let range = Range(fonudText.startIndex.advancedBy(1)...fonudText.endIndex.advancedBy(-2))
        return fonudText.substringWithRange(range)
    }
    func processorName() -> String{
        return "emoticons"
    }

}
