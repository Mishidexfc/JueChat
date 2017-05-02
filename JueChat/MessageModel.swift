//
//  MessageModel.swift
//  JueChat
//
//  Created by Jue Wang on 2017/3/26.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import Foundation
import ObjectMapper
class MessageModel:NSObject{
    var avatarImgURL:String?
    var userID:String?
    var userName:String?
    var lastMsg:String?
    var atrriStr:NSAttributedString?
    var lastMsgType:String?
    var dateString:String?
    var numOfUnreadMsg:String?
    var image:UIImage?
   }

