//
//  TranslationViewController.swift
//  JueChat
//
//  Created by Jue Wang on 2017/5/1.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit
class TransalationViewController:UIViewController{
    @IBOutlet weak var OriginTextView: UITextView!
    @IBOutlet weak var ResultTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func GoTranslation(_ sender: UIButton) {
        if self.OriginTextView.text != ""{
            let temp=TransFeatures()
            self.ResultTextView.text="Waiting for translation result."
            temp.translate(yourStr: self.OriginTextView.text, completion: self.setResult(resultStr:))
        }
    }
    func setResult(resultStr:String){
        self.ResultTextView.text=resultStr
    }
    
}
