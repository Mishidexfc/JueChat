//
//  UpperRightButtonsInChatView.swift
//  JueChat
//
//  Created by Jue Wang on 2017/3/24.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  The upper right view in ChatView for some additional features.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 3/25 Create this class
//--------------------------------------------------------------

import UIKit
import SnapKit
import RxSwift
import RxCocoa
private let containerWidth: CGFloat = 140   //container view width
private let containerHeight: CGFloat = 148    //container view height
private let singleButtonHeight: CGFloat = 44   //button height
private let firstButtonY: CGFloat = 12 //the first button Y value
class UpperRightButtonsInChatView:UIView{
    weak var delegate: UpperRightViewDelegate?
    let disposeBag = DisposeBag()
    override init (frame: CGRect) {
        super.init(frame : frame)
        self.initButtons()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
        self.initButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// init the buttons in upper right view
    func initButtons(){
        self.backgroundColor=UIColor.clear
        let buttonTitle = ["New Chat","Add Friend","Scan"] // the titles
        let actionImages = [UIImage(named:"contacts_add_newmessage")!,UIImage(named:"barbuttonicon_add_cube")!,UIImage(named:"contacts_add_scan")!] // Image sets
        let contentView=UIView()
        contentView.backgroundColor = UIColor.clear
        self.addSubview(contentView)
        contentView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.snp.top).offset(14)
            make.right.equalTo(self.snp.right).offset(-5)
            make.width.equalTo(140)
            make.height.equalTo(148)
        }
        
        let contentBackgroundOri:UIImage = UIImage(named:"MessageRightTopBg")!
        let stretchInsets = UIEdgeInsetsMake(14, 6, 6, 34)
        let backgroundResized=contentBackgroundOri.resizableImage(withCapInsets: stretchInsets, resizingMode: .stretch)
        let contentBackgroundFinal=UIImageView(image:backgroundResized)
        contentView.addSubview(contentBackgroundFinal)
        contentBackgroundFinal.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }
        var yValue = firstButtonY
        for index in 0 ..< actionImages.count {
            let itemButton: UIButton = UIButton(type: .custom)
            itemButton.backgroundColor = UIColor.clear
            itemButton.titleLabel!.font = UIFont.systemFont(ofSize: 17)
            itemButton.setTitleColor(UIColor.white, for: UIControlState())
            itemButton.setTitleColor(UIColor.white, for: .highlighted)
            itemButton.setTitle(buttonTitle[index], for: .normal)
            itemButton.setTitle(buttonTitle[index], for: .highlighted)
            itemButton.setImage(actionImages[index], for: .normal)
            itemButton.setImage(actionImages[index], for: .highlighted)
            itemButton.addTarget(self, action: #selector(self.buttonTaped(_:)), for: UIControlEvents.touchUpInside)
            itemButton.contentHorizontalAlignment = .left
            itemButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
            itemButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            itemButton.tag = index
            contentView.addSubview(itemButton)
            
            itemButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(contentView.snp.top).offset(yValue)
                make.right.equalTo(contentView.snp.right)
                make.width.equalTo(contentView.snp.width)
                make.height.equalTo(singleButtonHeight)
            }
            yValue += singleButtonHeight
        }

        let tapViewGesture=UITapGestureRecognizer()
        self.addGestureRecognizer(tapViewGesture)
        tapViewGesture.rx.event.subscribe { _ in
            if(self.isHidden == false){
                self.hideSelf(isHide: true)
            }
            }.addDisposableTo(self.disposeBag)
        
        
    }
    
    /// Gesture handler for tap the button
    func buttonTaped(_ sender:UIButton){
        guard let delegate = self.delegate else {
            self.hideSelf(isHide: true)
            return
        }
        
        let taptype = UpperRightViewItemType(rawValue:sender.tag)!
        delegate.floatViewTapItemIndex(taptype)
        self.hideSelf(isHide: true)
    }
    
    /// auto set the hidden attributtion
    func hideSelf(isHide:Bool){
        if isHide{
            self.alpha=1.0
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha=0.0
            }, completion: {(finished:Bool)->Void in self.isHidden=true
                self.alpha=1.0})
            
        }else{
            self.alpha=0.0
            self.isHidden=false
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha=1.0
            }, completion: {(finished:Bool)->Void in })
        }
        
    }
    
}

// Delegate for upper-right view
protocol UpperRightViewDelegate: class {
    /**
     Tap the item with index
     */
    func floatViewTapItemIndex(_ type: UpperRightViewItemType)
}

enum UpperRightViewItemType: Int {
    case newChat, addFriend, scan
}



