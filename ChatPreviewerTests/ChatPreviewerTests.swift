//
//  ChatPreviewerTests.swift
//  ChatPreviewerTests
//
//  Created by Ahmed Essam on 3/26/16.
//  Copyright © 2016 Ahmed Essam. All rights reserved.
//

import XCTest
@testable import ChatPreviewer

class ChatPreviewerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func delegateTest(text: String, expected: String, processor: TextProcessorExtension){
        let tp = TextProcessor()
        tp.addTextPattern(processor)
        let result = tp.processText(text)
        if let arr = result[processor.processorName()]{
            if arr.count == 1 {
                if !arr[0].isEqualToString(expected){
                    assertionFailure("The " + processor.processorName() + " must be " + expected)
                }
            }else{
                assertionFailure("Array should have exactly 1 " + processor.processorName())
            }
        }else{
            assertionFailure("Process output should had " + processor.processorName())
        }
    }
    
    func testMentionsBegining() {
        delegateTest("@Ahmed was here", expected: "Ahmed", processor: MentionsProcessor())
    }
    
    func testMentionsMiddle() {
        delegateTest("Was @Ahmed here?", expected: "Ahmed", processor: MentionsProcessor())
    }
    
    func testMentionsEnd() {
        delegateTest("Did someone contact @Ahmed", expected: "Ahmed", processor: MentionsProcessor())
    }
    
    func testManyMentions() {
        let tp = TextProcessor()
        tp.addTextPattern(MentionsProcessor())
        let result = tp.processText("@Ahmed @Shady @Ali will come")
        if let arr = result["mentions"]{
            if !(arr.count==3){
                assertionFailure("Array must be contain 3 mentions")
            }
        }

    }
    
    func testAtInTheMiddle() {
        let tp = TextProcessor()
        tp.addTextPattern(MentionsProcessor())
        let result = tp.processText("Sending email ahmed@me.com will it work?")
        if let arr = result["mentions"]{
            if arr.count>0{
                assertionFailure("Array must be empty")
            }
        }

    }
    
    func testHashtagsBegining() {
        delegateTest("#Party time", expected: "Party", processor: HashtagsProcessor())
    }
    
    func testHashtagsMiddle() {
        delegateTest("What time is it? #Party time", expected: "Party", processor: HashtagsProcessor())
    }
    
    func testHashtagsEnd() {
        delegateTest("It is time to #Party", expected: "Party", processor: HashtagsProcessor())
    }
    
    func testManyHashtags() {
        let tp = TextProcessor()
        let htp = HashtagsProcessor()
        tp.addTextPattern(htp)
        let result = tp.processText("#Party #Hard #Always will come")
        if let arr = result[htp.processorName()]{
            if !(arr.count==3){
                assertionFailure("Array must be contain 3 mentions")
            }
        }else{
            assertionFailure("Result must contain hashtags")
        }
    }
    
    func testHashInTheMiddle() {
        let tp = TextProcessor()
        let htp = HashtagsProcessor()
        tp.addTextPattern(htp)
        let result = tp.processText("What will it say about this me#you")
        if let arr = result[htp.processorName()]{
            if arr.count>0{
                assertionFailure("Array must be empty")
            }
        }
    }
    
    func testEmojiBegining() {
        delegateTest("(android) guess who is here", expected: "android", processor: EmoticonProcessor())
    }
    
    func testEmojiMiddle() {
        delegateTest("Guess who is here (ashton) check it out", expected: "ashton", processor: EmoticonProcessor())
    }
    
    func testEmojiEnd() {
        delegateTest("Guess who is here (bicepright)", expected: "bicepright", processor: EmoticonProcessor())
    }
    
    func testManyEmoji() {
        let tp = TextProcessor()
        let htp = EmoticonProcessor()
        tp.addTextPattern(htp)
        let result = tp.processText("(bicepright) (ashton) (android)")
        if let arr = result[htp.processorName()]{
            if !(arr.count==3){
                assertionFailure("Array must be contain 3 mentions")
            }
        }else{
            assertionFailure("Result must contain hashtags")
        }

    }
    func testHTMLTitle() {
        delegateTest("<title>We are testing titles</title>", expected: "We are testing titles", processor: HTMLTitleProcessor())
    }
    
    func testHTMLFbPreviewImageWithSingleQuote() {
        delegateTest("<meta property=\"og:image\" content='http://media.filfan.com/images/NewsPics/FilfanNew/large/AASHRAF_3.jpg' />", expected: "http://media.filfan.com/images/NewsPics/FilfanNew/large/AASHRAF_3.jpg", processor: HTMLImageProcessor())
    }
    func testHTMLFbPreviewImageWithDoubleQuote() {
        delegateTest("<meta property=\"og:image\" content=\"http://media.filfan.com/images/NewsPics/FilfanNew/large/AASHRAF_3.jpg\"/>", expected: "http://media.filfan.com/images/NewsPics/FilfanNew/large/AASHRAF_3.jpg", processor: HTMLImageProcessor())
    }
    func testHTMLFbPreviewDescriptionWithSingleQuote() {
        delegateTest("<meta property='og:description' content='Test description'/>", expected: "Test description", processor: HTMLDescriptionProcessor())
    }
    func testHTMLFbPreviewDescriptionWithDoubleQuote() {
        delegateTest("<meta property=\"og:description\" content=\"Test description\"/>", expected: "Test description", processor: HTMLDescriptionProcessor())
    }
    
    func testURL(){
        let tp = TextProcessor.createFullProcessor()
        
        let result = tp.processText("Check the new website http://nbcolympics.com")
        
        if let links = result["links"]{
            if links.count==1{
                if let linksDictionary = links[0] as? [String:AnyObject]{
                    if let image = linksDictionary["image"] as? String{
                        if !(image=="https://s0.wp.com/wp-content/themes/vip/nbcsports-olympics-rio/img/facebook-default.png"){
                            assertionFailure("Image URL is not correct.")
                        }
                    }else{
                        assertionFailure("URL page should have preview image")
                    }
                    if let description = linksDictionary["description"] as? String{
                        if !(description=="NBC Olympics - Home of the 2016 Olympic Games in Rio"){
                            assertionFailure("description is not correct.")
                        }
                    }else{
                        assertionFailure("URL page should have description")
                    }
                    if let title = linksDictionary["title"] as? String{
                        if !(title=="NBC Olympics | Home of the 2016 Olympic Games in Rio"){
                            assertionFailure("title is not correct.")
                        }
                    }else{
                        assertionFailure("URL page should have title")
                    }
                    if let url = linksDictionary["url"] as? String{
                        if !(url=="http://nbcolympics.com"){
                            assertionFailure("url is not correct.")
                        }
                    }else{
                        assertionFailure("can't find URL")
                        
                    }
                }
            }
        }
    }
    
    func testAllInOne() {
        let tp = TextProcessor.createFullProcessor()
        
        let result = tp.processText("@ahmed check http://nbcolympics.com and lets have some #fun (bicepright)")
        if let mentions = result["mentions"]{
            if mentions.count==1{
                if !mentions[0].isEqualToString("ahmed"){
                    assertionFailure("ahmed must be in mentions")
                }
            }
        }
        if let hashtags = result["hashtags"]{
            if hashtags.count==1{
                if !hashtags[0].isEqualToString("fun"){
                    assertionFailure("fun must be in hashtags")
                }
            }
        }
        if let emoticons = result["emoticons"]{
            if emoticons.count==1{
                if !emoticons[0].isEqualToString("bicepright"){
                    assertionFailure("fun must be in bicepright")
                }
            }
        }
        if let links = result["links"]{
            if links.count==1{
                if let linksDictionary = links[0] as? [String:AnyObject]{
                    if let image = linksDictionary["image"] as? String{
                        if !(image=="https://s0.wp.com/wp-content/themes/vip/nbcsports-olympics-rio/img/facebook-default.png"){
                            assertionFailure("Image URL is not correct.")
                        }
                    }else{
                        assertionFailure("URL page should have preview image")
                    }
                    if let description = linksDictionary["description"] as? String{
                        if !(description=="NBC Olympics - Home of the 2016 Olympic Games in Rio"){
                            assertionFailure("description is not correct.")
                        }
                    }else{
                        assertionFailure("URL page should have description")
                    }
                    if let title = linksDictionary["title"] as? String{
                        if !(title=="NBC Olympics | Home of the 2016 Olympic Games in Rio"){
                            assertionFailure("title is not correct.")
                        }
                    }else{
                        assertionFailure("URL page should have title")
                    }
                    if let url = linksDictionary["url"] as? String{
                        if !(url=="http://nbcolympics.com"){
                            assertionFailure("url is not correct.")
                        }
                    }else{
                        assertionFailure("can't find URL")

                    }
                }
            }
        }
    }
}
