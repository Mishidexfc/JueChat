//
//  userInfoModel.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/18.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import Foundation
import SwiftyJSON
class userInfo{
    func getUserInfo()->MessageModel{
        let path = Bundle.main.path(forResource: "userInfo", ofType: "json")
        let jsonData=NSData(contentsOfFile:path!)
        let json = JSON(data:jsonData! as Data)
        let tempMsgModel=MessageModel()
        tempMsgModel.avatarImgURL=json["avatar_url"].stringValue
        tempMsgModel.userID=json["userID"].stringValue
        tempMsgModel.userName=json["nickName"].stringValue
    return tempMsgModel
    }
}
