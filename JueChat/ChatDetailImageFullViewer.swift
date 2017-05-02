//
//  ChatDetailImageFullViewer.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/28.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  the image detail when tap the image in the message.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/28 Create file
//--------------------------------------------------------------

import UIKit
import SnapKit
class ChatDetailImageFullViewer:UIViewController{
    var imageDetail:UIImageView?
    var imageSource:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGes=UITapGestureRecognizer(target: self, action: #selector(self.tapHandle(_:)))
        let strechGes=UIPinchGestureRecognizer(target: self, action: #selector(self.strechHandel(_:)))
        self.view.addGestureRecognizer(tapGes)
        self.view.addGestureRecognizer(strechGes)
        self.drawLayout()
    }
    
    func drawLayout(){
        self.view.backgroundColor=UIColor.black
        if self.imageDetail == nil{
        self.imageDetail = UIImageView()
        }
        self.imageDetail?.image=self.imageSource
        self.view.addSubview(self.imageDetail!)
        self.imageDetail?.snp.makeConstraints{(make) -> Void in
            make.center.equalTo(self.view.center)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func strechHandel(_ sender:UIGestureRecognizer){
    
    }
    func tapHandle(_ sender:UIGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
}
