//
//  MessageCellInChatView.swift
//  JueChat
//
//  Created by Jue Wang on 2017/3/23.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  The custom cell for ChatView's table view.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 3/25 Create this class
//--------------------------------------------------------------
import UIKit
class MessageCellInChatView:UITableViewCell{
    @IBOutlet weak var LabelName: UILabel!
    @IBOutlet weak var LabelMsgNumUnread: UILabel!
    @IBOutlet weak var LabelLastMsg: UILabel!
    @IBOutlet weak var LabelDate: UILabel!
    @IBOutlet weak var AvatarImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set the avatar and unread message circle.
        self.LabelMsgNumUnread.layer.masksToBounds=true
        self.LabelMsgNumUnread.layer.cornerRadius=self.LabelMsgNumUnread.frame.height/2
        self.AvatarImg.layer.masksToBounds=true
        self.AvatarImg.layer.cornerRadius=self.AvatarImg.frame.width/2/180*30
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
