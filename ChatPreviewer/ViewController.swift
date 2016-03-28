//
//  ViewController.swift
//  ChatPreviewer
//
//  Created by Ahmed Essam on 3/26/16.
//  Copyright © 2016 Ahmed Essam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var play: UILabel!
    @IBOutlet weak var process: UIButton!
    @IBOutlet weak var result: UITextView!
    @IBOutlet weak var input: UITextField!{
        didSet{
            input.delegate = self
        }
    }
    @IBAction func setCase(sender: UIButton) {
        var cases = ["@chris you around?","Good morning! (megusta) (coffee)",
                     "Olympics are starting soon; http://www.nbcolympics.com",
                     "@bob @john (success) such a #cool feature; https://twitter.com/jdorfman/status/430511497475670016",
                     "@ahmed check http://nbcolympics.com and lets have some #fun (bicepright)"]
        let index = sender.tag
        if 1...cases.count~=index{
            input!.text = cases[index-1]
        }
    }
    func injectHTML(text: String, find: String, color: String ) -> String{
        let toViewHTML = text.stringByReplacingOccurrencesOfString(find, withString: "<div style=\"display: inline-block; background-color:#"+color+"\">" + find + "</div>")
        return toViewHTML
    }
    func loopForHTML(text:String, items: Array<AnyObject>, color: String, itemFixer: (AnyObject)->String)->String{
        var formated = text
        for item in items{
            let str = itemFixer(item)
            formated = injectHTML(formated, find: str, color: color)
        }
        return formated
    }
    func processInputText(){
        
        // This is a quick and dirty viewer for the output.
        
        var toPrintOutput = String()
        var toViewHTML  = String()
        do {
            let tp = TextProcessor.createFullProcessor()
            if let text = input?.text!{
                let processed = tp.processText(text)
                toViewHTML = text
                let jsonData = try NSJSONSerialization.dataWithJSONObject(processed, options: NSJSONWritingOptions.PrettyPrinted)
                if let outputString = NSString(data: jsonData,encoding: NSUTF8StringEncoding) as? String{
                    toPrintOutput = outputString
                }
                
                if let mentions=processed["mentions"] {
                    toViewHTML = loopForHTML(toViewHTML, items: mentions, color:"efef88"){
                        "@" + ($0 as! String)
                    }
                }
                
                if let hashtags=processed["hashtags"] {
                    toViewHTML = loopForHTML(toViewHTML, items: hashtags, color:"ef88ea"){
                        "#" + ($0 as! String)
                    }
                }
                
                if let emoticons=processed["emoticons"] {
                    toViewHTML = loopForHTML(toViewHTML, items: emoticons, color:"88edef"){
                        "(" + ($0 as! String) + ")"
                    }
                }
                
                if let emoticons=processed["links"] {
                    toViewHTML = loopForHTML(toViewHTML, items: emoticons, color:"ea8888"){
                        let linkInfo = $0 as! Dictionary<String,String>
                        return linkInfo["url"]!
                    }
                }
            }
            
        } catch let error as NSError {
            toPrintOutput = error.description
        }
        weak var wself = self
        dispatch_async(dispatch_get_main_queue(), {
            wself!.result?.text = toPrintOutput
            wself!.process.enabled = true
            do{
                let attrStr = try NSAttributedString(data: toViewHTML.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                wself!.play?.attributedText = attrStr
            }catch _{
                
            }
        })
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return false
    }
    @IBAction func process(sender: AnyObject) {
        self.result?.text = "Please wait while fitching URL info"
        process.enabled = false
        weak var wself = self
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            wself!.processInputText()
        })
        

    }
}
