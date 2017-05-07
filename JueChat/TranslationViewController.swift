//
//  TranslationViewController.swift
//  JueChat
//
//  Created by Jue Wang on 2017/5/1.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit
class TransalationViewController:UIViewController{
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissTap=UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyBoard))
        self.view.addGestureRecognizer(dismissTap)
    }
 
    @IBAction func TranslateTap(_ sender: UIButton) {
        let tempTrs = TransFeatures()
        tempTrs.translate(yourStr: self.inputTextView.text, completion: self.setResult(resultStr:))
    }
    func setResult(resultStr:String){
    self.resultLabel.text=resultStr
    }
    func dismissKeyBoard(){
        self.inputTextView.endEditing(true)
    }
}
