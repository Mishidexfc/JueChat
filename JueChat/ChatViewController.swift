//
//  ChatViewController.swift
//  JueChat
//
//  Created by Jue Wang on 2017/3/12.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  The first view you will see in the app for Chat Board with unread messages.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 3/12 Create the basic view
//  Version 1.2 3/24 Implement the Upper-right float view
//  Version 1.3 3/25 Add the QR scanner
//  Version 2.0 3/26 Implement the costom MessageCellInChatView in xib
//  Version 2.1 4/17 Implement the entry information for detail
//--------------------------------------------------------------
import UIKit
import SwiftyJSON
import Eureka
import SnapKit
import swiftScan
class ChatViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource{
    var cellDataSource:[MessageModel]=[]
    var cellIndex:Int=0
    var tempStr:String=""{didSet{print(self.tempStr)}} // test for tranlastion api.
    var upperRightView:UpperRightButtonsInChatView!
    @IBOutlet var chatView: UIView!
    var tableView:UITableView?
    var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initChatTableCells()
        self.initUpperRightView()
        self.tableView?.keyboardDismissMode = .onDrag
    }
    
    /// When switch to other views, the upper right view should be hidden.
    override func viewWillDisappear(_ animated: Bool) {
        if !self.upperRightView.isHidden{
            self.upperRightView.isHidden=true
        }
    }
    
    /// Dismiss the keyboard
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.view.endEditing(true)
    }
    
    /// Init the upperRightview
    func initUpperRightView(){
        self.upperRightView=UpperRightButtonsInChatView()
        self.upperRightView.isHidden=true // Hidden it when be loaded.
        self.upperRightView.delegate=self
        self.view.addSubview(self.upperRightView)
        self.upperRightView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    
    /// Set the delegate and data source for table view and regist the custom cell.
    func initChatTableCells(){
        self.loadCellInfo()
        self.tableView?.estimatedRowHeight=65
        self.tableView=UITableView(frame:UIScreen.main.bounds,style:.plain)
        self.tableView!.delegate=self
        self.tableView!.dataSource=self
        self.tableView!.separatorColor = UIColor.lightGray
        self.tableView!.register(UINib(nibName:"MessageCellInChatView",bundle:nil), forCellReuseIdentifier: "chatCell")
        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints{(make)->Void in
            make.edges.equalTo(UIEdgeInsetsMake(44, 0, 0, 0))
        }
        
    }
    
    // Load data source, in my demo, there are 3 new chats in ChatView.
    private func loadCellInfo(){
        for i in 0...2{
            let tempModel = ChatViewModel()
            let tempMsgModel = tempModel.fetchDataForCells(index: i)
            self.cellDataSource.insert(tempMsgModel, at: i)
        }
    }
    
    //---------------------------------------------------------------------------
    // Implementation for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Select the row to enter into the chat detail.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailview=ChatDetailView()
        detailview.userIndex=indexPath.row
        let cell=self.tableView?.cellForRow(at: indexPath) as! MessageCellInChatView
        detailview.viewTitle=cell.LabelName.text
        self.hidesBottomBarWhenPushed=true
        self.tableView?.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(detailview, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellDataSource.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageCellInChatView = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! MessageCellInChatView
        cell.LabelName.text=cellDataSource[indexPath.row].userName
        if let imgUrl=NSData(contentsOf:NSURL.init(string: cellDataSource[indexPath.row].avatarImgURL!)! as URL){
            cell.AvatarImg.image = UIImage(data:imgUrl as Data)
        }
        cell.LabelMsgNumUnread.text=cellDataSource[indexPath.row].numOfUnreadMsg
        cell.LabelLastMsg.text = cellDataSource[indexPath.row].lastMsg
        cell.LabelDate.text = cellDataSource[indexPath.row].dateString
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    //---------------------------------------------------------------------------
    
    /// This function is to change the color to the corresponding color with navigation bar
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    /// tap "+" buuton to show/hide upper right view
    @IBAction func tapUpperRightButton(_ sender: UIBarButtonItem) {
        if self.upperRightView.isHidden{
            self.upperRightView.hideSelf(isHide: false)
        }
        else{
            self.upperRightView.hideSelf(isHide: true)
        }
        
    }
    
}


extension ChatViewController: UpperRightViewDelegate {
    /// Implement the delegate for upper right view
    func floatViewTapItemIndex(_ type: UpperRightViewItemType) {
        // types for upper right button
        switch type {
        case .newChat:
            break
        case .addFriend:
            break
        case .scan:
            self.goScan()
            break
        }
    }
    
    /// Start the Scanner
    func goScan(){
        // Set the parameters for scanner
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.isNeedShowRetangle = true;
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove;
        
        // Use the net style
        style.animationImage = UIImage(named: "qrcode_scan_light_green");
        
        // Color for 4 corners
        style.colorAngle = UIColor(red: 0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        // Color for rectangle
        style.colorRetangleLine = UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 18.0/255.0, alpha: 1.0)
        
        // Push the view controller
        let vc = LBXScanViewController()
        vc.scanStyle = style
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
        
        
    }
    
}

