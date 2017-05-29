//
//  ChatDetailView.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/14.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  The chat detail with messages, images and voice for each users.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/14 Create the basic table view and bottom bar
//  Version 1.1 4/15 Get the height of keyboard and update constrains
//  Version 1.2 4/19 Implement the alert with options for long-pressing the text label
//  Version 1.3 4/22 Now text,image,voice cells are avaliable!
//  Version 2.0 5/1  Now all the basic features are implemented!
//--------------------------------------------------------------

import UIKit
import SnapKit
import ImageViewer
class ChatDetailView:UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate{
    var userIndex:Int?
    var viewTitle:String?
    var bottomBar:ChatDetailBottomBar?
    var chatDetailTable:UITableView?
    var userInformation:MessageModel?
    var chatSource:[MessageModel]=[] // Data Source
    var emojiPanel:ChatDetailEmojiPanel?
    var emojiPanelHeight:Int=200
    var alertVC:UIAlertController?
    let tempTrs=TransFeatures()
    var transResult:String = ""
    var recordImg:UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadBottomBar()
        self.loadTableView()
        self.keyBoardHandle()
        
    }
    
    /// Initialize the table view of Chat Detail
    private func loadTableView(){
        let userTemp = userInfo()
        self.userInformation = userTemp.getUserInfo()
        self.title=self.viewTitle
        self.loadDataSource()
        self.chatDetailTable=UITableView()
        self.chatDetailTable?.delegate=self
        self.chatDetailTable?.dataSource=self
        self.chatDetailTable?.backgroundColor=UIColor.groupTableViewBackground
        self.chatDetailTable?.separatorStyle = .none
        self.view.addSubview(self.chatDetailTable!)
        self.chatDetailTable?.rowHeight=UITableViewAutomaticDimension
        self.chatDetailTable?.estimatedRowHeight=60
        self.chatDetailTable?.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.bottomBar!).offset(-50)
        }
        
        // register for costum cells of text,image,voice(or other types of cells in future)
        self.chatDetailTable?.register(UINib(nibName:"ChatDetailCell",bundle:nil), forCellReuseIdentifier: "TextCell")
        self.chatDetailTable?.register(UINib(nibName:"ChatDetailImageCell",bundle:nil), forCellReuseIdentifier: "ImageCell")
        self.chatDetailTable?.register(UINib(nibName:"ChatDetailVoiceCell",bundle:nil), forCellReuseIdentifier: "VoiceCell")
        self.chatDetailTable?.reloadData()
        self.view.bringSubview(toFront: self.recordImg!) //Because this image view for record is loaded earlier than table view, so it suppose to be brought to front at this point.
        self.recordImg?.isHidden=true
    }
    
    /// Initialize the data source from model.
    private func loadDataSource(){
        let tempModel=ChatDetailMsgModel()
        let numOfMsg=tempModel.getNumOfMessage(userIndex: self.userIndex!)
        for i in 0..<numOfMsg{
            self.chatSource.insert(tempModel.fetchDataForCells(index: i, userIndex: self.userIndex!), at: i)
            self.chatSource[i].atrriStr=NSAttributedString(string: self.chatSource[i].lastMsg!)
        }
    }
    
    /// Initialize the bottom bar
    private func loadBottomBar(){
        self.bottomBar = Bundle.main.loadNibNamed("ChatDetailBottomBar", owner: nil, options: nil)?.first as? ChatDetailBottomBar // load the view in xib file
        self.bottomBar?.InputTextField.delegate=self
        self.view.addSubview(self.bottomBar!)
        self.bottomBar?.InputTextField.returnKeyType = .send
        self.bottomBar?.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(50)
        }
        // Load the image for long press the record button.
        self.recordImg=UIImageView(image: UIImage(named: "RecordingBkg"))
        self.view.addSubview(self.recordImg!)
        self.recordImg?.snp.makeConstraints{(make)-> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(124)
            make.height.equalTo(200)
        }
        self.recordImg?.backgroundColor=UIColor.darkGray
        self.bottomBar?.parentInstance=self
        self.bottomBar?.InputTextField.returnKeyType = .send
        self.loadEmojiKeyBoard()
    }
    
    /// The emoji keyboard for chat
    private func loadEmojiKeyBoard(){
        self.bottomBar?.emojiKeyBoard=Bundle.main.loadNibNamed("ChatDetailEmojiPanel", owner: nil, options: nil)?.first as? ChatDetailEmojiPanel
        self.emojiPanel = self.bottomBar?.emojiKeyBoard
        self.emojiPanel?.parentInstance=self
        self.view.addSubview(self.emojiPanel!)
        self.emojiPanel?.snp.makeConstraints{(make)->Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(self.emojiPanelHeight)
            make.height.equalTo(self.emojiPanelHeight)
        }
        self.emojiPanel?.isHidden=true
    }
    
    // Implement send message when tap the send button
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text != "\n"{
            return true
        }
        else{
            // Refresh the data source
            let myInfoCls=userInfo()
            let myInfo=myInfoCls.getUserInfo()
            myInfo.lastMsgType = "text"
            myInfo.lastMsg=self.bottomBar?.InputTextField.text
            myInfo.atrriStr=self.bottomBar?.InputTextField.attributedText
            myInfo.avatarImgURL="Avatar1"
            self.chatSource.append(myInfo)
            let cellPath=IndexPath(row: self.chatSource.count-1, section: 0)
            self.chatDetailTable?.insertRows(at: [cellPath], with: .bottom)
            self.bottomBar?.InputTextField.text=""
            let secon = 0 //最后一个分组的索引（0开始，如果没有分组则为0）
            let rows = self.chatSource.count-1 //最后一个分组最后一条项目的索引
            let indexPath = IndexPath(row: rows, section: secon)
            self.chatDetailTable?.scrollToRow(at: indexPath, at:.bottom, animated: false)
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Insert the row of Chat table by loading the type of message.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleSource = self.chatSource[indexPath.row]
        var notUserSelf=true
        if self.userInformation?.userName==singleSource.userName{
            notUserSelf=false
        }
        if let cellType=self.chatSource[indexPath.row].lastMsgType{
            switch cellType {
            case "image":
                let cell=self.chatDetailTable?.dequeueReusableCell(withIdentifier: "ImageCell") as! ChatDetailImageCell
                cell.avatarImg.image=UIImage(named:(singleSource.avatarImgURL)!)
                cell.userNameLabel.text=singleSource.userName
                if singleSource.image != nil{
                    cell.messageImage.image=singleSource.image
                }
                else{
                    cell.messageImage.image=UIImage(named:singleSource.lastMsg!)
                }
                cell.drawLayout(whichSide: notUserSelf)
                cell.selectionCallback=[self.getViewInstance()] // Send the closure into cell class
                cell.selectionStyle = .none // no color when selected.
                return cell
            case "text":
                let cell=self.chatDetailTable?.dequeueReusableCell(withIdentifier: "TextCell") as! ChatDetailCell
                cell.avatarImage.image=UIImage(named:(singleSource.avatarImgURL)!)
                cell.userNameLabel.text=singleSource.userName
                cell.TextLabel.attributedText=singleSource.atrriStr
                cell.TextLabel.isUserInteractionEnabled=true
                cell.drawLayout(whichSide: notUserSelf)
                cell.selectionCallback=[self.copyText(thisModel: singleSource),self.splitText(thisModel: singleSource),self.TranslationText(thisModel: singleSource)]
                cell.selectionStyle = .none
                return cell
            case "voice":
                let cell=self.chatDetailTable?.dequeueReusableCell(withIdentifier: "VoiceCell") as! ChatDetailVoiceCell
                cell.avatarImage.image=UIImage(named:(singleSource.avatarImgURL)!)
                cell.userNameLabel.text=singleSource.userName
                cell.drawLayout(whichSide: notUserSelf, fileName: singleSource.lastMsg!)
                cell.selectionStyle = .none
                return cell
            default:
                break
            }
        }
        else{
            print("Error: Check your dataSource")
        }
        return UITableViewCell()
    }
    
    /// When tap the table view, the keyboard should be dismissed.
    func tapHandle(_ sender:UITapGestureRecognizer){
        self.alertVC?.dismiss(animated: true, completion: nil)
    }
    
    /// Automaticly calculating the height for each cell.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
extension ChatDetailView{
    
    /// Copy the text in the message.
    func copyText(thisModel:MessageModel)->(()->Void){
        return{UIPasteboard.general.string=thisModel.lastMsg!}
    }
    
    /// Spilt the string into words by using collcetion view.
    func splitText(thisModel:MessageModel)->(()->Void){
        return{
            let resultTokens=self.tempTrs.splitString(yourStr: thisModel.lastMsg!)
            if resultTokens.count>0{
                let storyboard = UIStoryboard(name: "ToolOCR", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ToolOCRmain") as! ToolOCRViewController
                vc.tokens=resultTokens
                vc.title="Split String"
                self.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    /// Using Translation Api
    func TranslationText(thisModel:MessageModel)->(()->Void){
        return{
            self.tempTrs.translate(yourStr: thisModel.lastMsg!, completion: self.showTrsResult(yourstr:))
        }
    }
    
    /// Set the result and pop out the alert with translation result.
    func showTrsResult(yourstr:String){
        //print(yourstr)
        self.transResult=yourstr
        self.alertVC = UIAlertController(title: "Translation Result", message: yourstr, preferredStyle: .alert)
        let doneAlert=UIAlertAction(title: "Done", style: .default, handler: nil)
        let copyAlert=UIAlertAction(title: "Copy", style: .destructive, handler: {action in
            UIPasteboard.general.string=yourstr
        })
        self.alertVC?.addAction(doneAlert)
        self.alertVC?.addAction(copyAlert)
        self.present(self.alertVC!, animated: true, completion: {
            self.alertVC?.view.superview?.isUserInteractionEnabled = true
            self.alertVC?.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapHandle(_:))))})
    }
}

extension ChatDetailView{
    /// Return the chatdetailview's self view controller.
    func getViewInstance()->(()->ChatDetailView){
        return {return self}
    }
}

extension ChatDetailView{
    
    /// Add notifications for keyboard about will show/will hide keyboard events.
    func keyBoardHandle(){
        self.chatDetailTable?.keyboardDismissMode = .onDrag
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailView.dismissKeyboard))
        self.chatDetailTable?.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// Function for dismiss keyboard including the keyboard, emoji keyboard and others.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
        if self.emojiPanel?.isHidden==false{
            UIView.animate(withDuration: 0.2){
                self.bottomBar?.snp.updateConstraints{(make)->Void in
                    make.bottom.equalTo(0)
                }
                self.emojiPanel?.snp.updateConstraints{(make)->Void in
                    make.bottom.equalTo(-self.emojiPanelHeight)
                }
                self.view.layoutIfNeeded()
                
            }
            self.emojiPanel?.isHidden=true
            self.view.bringSubview(toFront: self.bottomBar!)
        }
    }
    func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            print(keyboardSize.height)
            
            self.bottomBar?.snp.updateConstraints{(make) -> Void in
                make.bottom.equalTo(0).offset(-keyboardSize.height)
            }
            self.chatDetailTable?.snp.updateConstraints{(make) -> Void in
                make.bottom.equalTo(self.bottomBar!).offset(-50)
            }
            
            //self.chatDetailTable?.reloadData()
        }
        else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    func keyboardWillHidden(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            print(keyboardSize.height)
            self.bottomBar?.snp.updateConstraints{(make) -> Void in
                make.bottom.equalTo(0)
            }
            self.chatDetailTable?.snp.updateConstraints{(make) -> Void in
                make.bottom.equalTo(self.bottomBar!).offset(-50)
                
            }
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
}
