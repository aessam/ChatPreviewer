//
//  ViewController.swift
//  ChatPreviewer
//
//  Created by Ahmed Essam on 3/26/16.
//  Copyright © 2016 Ahmed Essam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
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
                     "@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016",
                     "@ahmed check http://nbcolympics.com and lets have some #fun (bicepright)"]
        let index = sender.tag
        if 1...cases.count~=index{
            input!.text = cases[index-1]
        }
    }
    func processInputText(){
        var toPrintOutput = String()
        do {
            let tp = TextProcessor.createFullProcessor()
            if let text = input?.text!{
                let processed = tp.processText(text)
                let jsonData = try NSJSONSerialization.dataWithJSONObject(processed, options: NSJSONWritingOptions.PrettyPrinted)
                if let outputString = NSString(data: jsonData,encoding: NSUTF8StringEncoding) as? String{
                    toPrintOutput = outputString
                }
                
            }
            
        } catch let error as NSError {
            toPrintOutput = error.description
        }
        weak var wself = self
        dispatch_async(dispatch_get_main_queue(), {
            wself!.result?.text = toPrintOutput
            wself!.process.enabled = true
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
