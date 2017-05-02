//
//  ChatDetailMsgModel.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/14.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import Alamofire
class ChatDetailMsgModel{
    func getNumOfMessage(userIndex:Int)->Int{
        let fileResource="chat"+String(userIndex)
        let path = Bundle.main.path(forResource: fileResource, ofType: "json")
        let jsonData=NSData(contentsOfFile:path!)
        let json = JSON(data:jsonData! as Data)
        let num = json["numberOfMessage"].intValue
        return num
    }
    func fetchDataForCells(index:Int,userIndex:Int)->MessageModel{
        let fileResource="chat"+String(userIndex)
        let path = Bundle.main.path(forResource: fileResource, ofType: "json")
        let jsonData=NSData(contentsOfFile:path!)
        let json = JSON(data:jsonData! as Data)
        let tempMsgModel=MessageModel()
        tempMsgModel.avatarImgURL=json["data"][index]["avatar_url"].stringValue
        tempMsgModel.userName=json["data"][index]["nickname"].stringValue
        tempMsgModel.dateString=json["data"][index]["ctime"].stringValue
        tempMsgModel.lastMsg=json["data"][index]["msgContent"].stringValue
        tempMsgModel.lastMsgType = json["data"][index]["msgType"].stringValue
        return tempMsgModel
    }
}
