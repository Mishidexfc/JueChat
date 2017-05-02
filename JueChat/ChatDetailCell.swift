//
//  ChatDetailCell.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/16.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  cell for text message.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/16 Create file
//  Version 1.1 4/19 Implement the autolayout and figuring out the exact number for it.
//  Version 1.2 4/20 Implement long press pop menu by alert controller
//  Version 2.0 4/22 Change the pop menu by using UIMenuController instead.
//--------------------------------------------------------------
import UIKit
import SnapKit
class ChatDetailCell:UITableViewCell{
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var TextLabel: UILabel!
    var menu=UIMenuController.shared // menu controller
    var selectionCallback: [(() -> Void)]?
    var isPressing=false
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Set the style for text cell, true for left and false for right side(myself)
    func prepareStyle(whichSide:Bool){
        if whichSide{
            self.TextLabel.layer.borderColor=UIColor.lightGray.cgColor
            self.TextLabel.backgroundColor=UIColor.white
            self.TextLabel.textColor=UIColor.black
            self.TextLabel.textAlignment = .left
        }
        else{
            self.TextLabel.layer.borderColor=UIColor.white.cgColor
            self.TextLabel.backgroundColor=UIColor.init(red: 0.43, green: 0.62, blue: 0.92, alpha: 1.0)
            self.TextLabel.textColor=UIColor.init(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
            self.TextLabel.textAlignment = .left
        }
        
        self.TextLabel.layer.cornerRadius=5
        self.TextLabel.layer.borderWidth=0.5
        self.TextLabel.clipsToBounds=true
        let longPressGes=UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressLabel(_:)))
        longPressGes.delegate=self
        self.TextLabel.addGestureRecognizer(longPressGes)
    }
    
    /// long press the text to show the uimenu
    func handleLongPressLabel(_ sender : UIGestureRecognizer){
        print("LongPress")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            self.becomeFirstResponder()
            let copyItem=UIMenuItem(title: "Copy", action: #selector(self.startCopy))
            let splitItem=UIMenuItem(title: "Split", action: #selector(self.startSplit))
            let trsItem=UIMenuItem(title: "Translation", action: #selector(self.startTranslation))
            menu.menuItems = [copyItem,splitItem,trsItem]
            menu.setTargetRect(self.TextLabel.bounds, in: self.TextLabel)
            menu.setMenuVisible(true, animated: true)
        }
    }
    func startCopy(){
        self.selectionCallback?[0]()
    }
    func startSplit(){
        self.selectionCallback?[1]()
    }
    func startTranslation(){
        self.selectionCallback?[2]()
    }
    
    // Override the value for label to become first responder.
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    // Let menu perform the named actions.
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if(action == #selector(self.startCopy)||action == #selector(self.startSplit)||action == #selector(self.startTranslation))
        {
            return true
            
        }
        else
        {
            return false
        }
    }
    
    /// Calculate the height for label.
    func getLabHeight(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize.height
    }
    

    func getNewHeight()->CGFloat{
        let labelContent=self.TextLabel.text
        let myFont=self.TextLabel.font
        let width=250
        let newHeight=self.getLabHeight(labelStr: labelContent!, font: myFont!, width: CGFloat(width))
        return newHeight
    }
    
    /// Set the layout and contrains for cell.
    func drawLayout(whichSide:Bool){
        if whichSide{//left side from other
            self.avatarImage.snp.removeConstraints()
            self.avatarImage.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(10)
                make.top.equalTo(5)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            self.userNameLabel.snp.removeConstraints()
            self.userNameLabel.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(20)
                make.right.lessThanOrEqualTo(-200)
                //make.width.greaterThanOrEqualTo(45)
                make.left.equalTo(60)
                make.top.equalTo(5)
            }
            self.TextLabel.snp.removeConstraints()
            self.TextLabel.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(60)
                make.top.equalTo(25)
                make.width.greaterThanOrEqualTo(35)
                make.width.lessThanOrEqualTo(200)
                make.height.greaterThanOrEqualTo(36.5)
                make.bottom.equalTo(0)
            }
        }
        else{//right side from myself
            self.avatarImage.snp.removeConstraints()
            self.avatarImage.snp.makeConstraints{(make) -> Void in
                make.right.equalTo(-10)
                make.top.equalTo(5)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            self.userNameLabel.snp.removeConstraints()
            self.userNameLabel.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(20)
                //make.width.greaterThanOrEqualTo(45)
                make.right.equalTo(-60)
                make.top.equalTo(5)
            }
            self.TextLabel.snp.removeConstraints()
            self.TextLabel.snp.makeConstraints{(make) -> Void in
                make.right.equalTo(-60)
                make.width.greaterThanOrEqualTo(35)
                make.width.lessThanOrEqualTo(200)
                make.top.equalTo(25)
                make.height.greaterThanOrEqualTo(36.5)
                make.bottom.equalTo(0)
            }
        }
        self.prepareStyle(whichSide: whichSide)
    }
}
