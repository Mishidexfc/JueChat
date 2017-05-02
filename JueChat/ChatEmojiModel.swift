//
//  ChatEmojiModel.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/30.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import Foundation

class ChatEmojiModel{
    var imageString : String!
    var text : String!
    
    init(fromDictionary dictionary: NSDictionary){
        let imageText = dictionary["image"] as! String
        imageString = "\(imageText)@2x"
        text = dictionary["text"] as? String
    }
}
