//
//  ChatViewModel.swift
//  JueChat
//
//  Created by Jue Wang on 2017/3/26.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import Alamofire
class ChatViewModel{
    func fetchDataForCells(index:Int)->MessageModel{
        let path = Bundle.main.path(forResource: "chatViewMessage", ofType: "json")
        let jsonData=NSData(contentsOfFile:path!)
        let json = JSON(data:jsonData! as Data)
        let tempMsgModel=MessageModel()
        tempMsgModel.avatarImgURL=json["data"][index]["avatar_url"].stringValue
        tempMsgModel.userName=json["data"][index]["nickname"].stringValue
        tempMsgModel.dateString=json["data"][index]["last_message"]["ctime"].stringValue
        tempMsgModel.numOfUnreadMsg = json["data"][index]["message_unread_num"].stringValue
        tempMsgModel.lastMsg=json["data"][index]["last_message"]["message"].stringValue
        return tempMsgModel
    }
}
