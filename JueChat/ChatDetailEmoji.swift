//
//  ChatDetailEmoji.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/27.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  single emoji for emoji keyboard
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/27 Create file
//--------------------------------------------------------------

import UIKit
class ChatDetailEmoji:UICollectionViewCell{
    @IBOutlet weak var emojiImage: UIImageView!
    var imageName:String?
    var emojiStr:String?
    var emojiIndex:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
