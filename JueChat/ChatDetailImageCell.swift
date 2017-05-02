//
//  ChatDetailImageCell.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/18.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  cell for image message.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/18 Create file
//--------------------------------------------------------------

import UIKit
class ChatDetailImageCell:UITableViewCell{
    //-------------------------------------
    // minimum and maximum size for image
    let maxWidth:CGFloat=200.0
    let maxHeight:CGFloat=200.0
    let minWidth:CGFloat=45.0
    let minHeight:CGFloat=45.0
    //-------------------------------------
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    var selectionCallback: [(() -> ChatDetailView)]?
    var menu=UIMenuController.shared
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// Resize the image
    func getResizePara()->CGFloat{
        var resizePara:CGFloat=1
        let imageWidth=self.messageImage.image?.size.width
        let imageHeight=self.messageImage.image?.size.height
        if(imageWidth! > self.maxWidth && imageHeight! > self.maxHeight){
            resizePara=self.maxWidth/max(imageHeight!,imageWidth!)
            return resizePara
        }
        if(imageWidth! > self.maxWidth){
            resizePara=self.maxWidth/imageWidth!
            return resizePara
        }
        if(imageHeight! > self.maxHeight){
            resizePara=self.maxHeight/imageHeight!
            return resizePara
        }
        return resizePara
    }
    
    /// Set the layout for image cell
    func drawLayout(whichSide:Bool){
        let resizePara=self.getResizePara()
        if whichSide{//left side from other
            self.avatarImg.snp.removeConstraints()
            self.avatarImg.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(10)
                make.top.equalTo(5)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            self.userNameLabel.snp.removeConstraints()
            self.userNameLabel.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(20)
                make.right.lessThanOrEqualTo(-200)
                make.left.equalTo(60)
                make.top.equalTo(self.contentView.snp.top).offset(5)
            }
            self.messageImage.snp.removeConstraints()
            self.messageImage.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(60)
                make.top.equalTo(25)
                
                make.height.greaterThanOrEqualTo(45)
                make.width.equalTo((self.messageImage.image?.size.width)!*resizePara)
                make.height.equalTo((self.messageImage.image?.size.height)!*resizePara)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-5)
            }
        }
        else{//right side from myself
            self.avatarImg.snp.removeConstraints()
            self.avatarImg.snp.makeConstraints{(make) -> Void in
                make.right.equalTo(-10)
                make.top.equalTo(5)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            self.userNameLabel.snp.removeConstraints()
            self.userNameLabel.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(20)
                make.left.lessThanOrEqualTo(200)
                make.right.equalTo(-60)
                make.top.equalTo(self.contentView.snp.top).offset(5)
            }
            self.messageImage.snp.removeConstraints()
            self.messageImage.snp.makeConstraints{(make) -> Void in
                make.right.equalTo(-60)
                make.top.equalTo(25)
                make.height.greaterThanOrEqualTo(45)
                make.width.equalTo((self.messageImage.image?.size.width)!*resizePara)
                make.height.equalTo((self.messageImage.image?.size.height)!*resizePara)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-5)
            }
        }
        self.messageImage.clipsToBounds=true
        self.prepareStyle(whichSide: whichSide)
    }
    
    /// Set the color and interaction.
    func prepareStyle(whichSide:Bool){
        self.contentView.backgroundColor=UIColor.groupTableViewBackground
        self.messageImage.layer.borderColor=UIColor.lightGray.cgColor
        self.messageImage.layer.borderWidth=0.5
        let longPressGes=UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressImage(_:)))
        longPressGes.delegate=self
        self.messageImage.isUserInteractionEnabled=true
        self.messageImage.addGestureRecognizer(longPressGes)
        let tapPressGes=UITapGestureRecognizer(target: self, action: #selector(self.handleTapImage(_:)))
        self.messageImage.addGestureRecognizer(tapPressGes)
    }
    
    /// Long press image for menu controller.
    func handleLongPressImage(_ sender : UIGestureRecognizer){
        print("LongPress")
        if sender.state == .ended {
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            self.becomeFirstResponder()
            let copyItem=UIMenuItem(title: "Save", action: #selector(self.saveImage))
            let ocrItem=UIMenuItem(title: "Recognize", action: #selector(self.goOCR))
            menu.menuItems = [copyItem,ocrItem]
            menu.setTargetRect(self.messageImage.bounds, in: self.messageImage)
            // 5. 显示菜单
            menu.setMenuVisible(true, animated: true)
            //Do Whatever You want on Began of Gesture
        }
    }
    
    /// Save the image to album
    func saveImage(){
        UIImageWriteToSavedPhotosAlbum(self.messageImage.image!, nil, nil, nil)
        var parentViewController:ChatDetailView?
        if (selectionCallback != nil){
            parentViewController = selectionCallback?[0]()
        }
        else{
            return
        }
        if(parentViewController != nil){
            let alertSave=UIAlertAction(title: "Done", style: .default, handler: nil)
            let alertVc=UIAlertController(title: "Success", message: "The image has been saved to album.", preferredStyle: .alert)
            alertVc.addAction(alertSave)
            parentViewController?.alertVC=alertVc
            parentViewController?.present((parentViewController?.alertVC)!, animated: true, completion: {
                parentViewController?.alertVC?.view.superview?.isUserInteractionEnabled = true
                parentViewController?.alertVC?.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: parentViewController, action: #selector(parentViewController?.tapHandle(_:))))})
        }
        else{
            return
        }
    }
    
    /// Open Ocr view controller.
    func goOCR(){
        let storyboard = UIStoryboard(name: "ToolOCR", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ToolOCRmain") as! ToolOCRViewController
        vc.title="Recognized result"
        vc.preImage=self.messageImage.image
        var parentViewController:ChatDetailView?
        if (selectionCallback != nil){
            parentViewController = selectionCallback?[0]()
        }
        else{
            return
        }
        if(parentViewController != nil){
            parentViewController?.hidesBottomBarWhenPushed=true
            parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            return
        }
        
    }
    
    /// Tap the image to see the detail.
    func handleTapImage(_ sender : UIGestureRecognizer){
        var parentViewController:ChatDetailView?
        if (selectionCallback != nil){
            parentViewController = selectionCallback?[0]()
        }
        else{
            return
        }
        if(parentViewController != nil){
            let vc = ChatDetailImageFullViewer()
            vc.modalTransitionStyle = .crossDissolve
            vc.imageSource=self.messageImage.image
            parentViewController?.present(vc, animated: true, completion: nil)
            
        }
        else{
            return
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if(action == #selector(self.saveImage)||action == #selector(self.goOCR))
        {
            return true
            
        }
        else
        {
            return false
        }
    }
}
