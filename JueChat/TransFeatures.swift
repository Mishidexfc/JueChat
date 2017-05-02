//
//  TransFeatures.swift
//  JueChat
//
//  Created by Jue Wang on 2017/3/26.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 3/27 Use Youdao Translation Api
//  Version 1.1 3/28 Import Tesseract-OCR
//  Version 1.2 4/12 Implement split string to tokens
//  Version 1.3 4/19 Improvement for translation url which can support Chinese token now.
//--------------------------------------------------------------
import Foundation
import Alamofire
import SwiftyJSON
import TesseractOCR
class TransFeatures{
    /**
     **Translation your string with youdao(default) translate api.**
     * Sending the reqest by alamofire.
     * yourStr //the string you want to be translated,english or other languages
     * completion //a closure from view class because the request of alamofire is async
     */
    func translate(yourStr:String, completion: @escaping (_ result:String) -> Void){
        var resultStr:String=""
        let url:URLConvertible="http://fanyi.youdao.com/openapi.do"
        //let url:URLConvertible="http://fanyi.youdao.com/openapi.do?keyfrom=JueChat&key=400781010&type=data&doctype=json&version=1.1&q=\(yourStr)"
        let para:Parameters=["keyfrom":"JueChat","key":"400781010","type":"data","doctype":"json","version":"1.1","q":yourStr]
        Alamofire.request(url, parameters: para).responseJSON {response in
            switch(response.result) {
            case .success(_):
                if let jsonData = response.result.value {
                    let json=JSON(jsonData)
                    //print(json)
                    resultStr=json["translation"][0].string!
                    completion(resultStr)
                }
                break
            case .failure(_):
                print(response.result.error ?? "")
                if response.result.error?._code == NSURLErrorTimedOut{
                    //TODO: Show Alert view on netwok connection.
                }
                break
            }
            
        }
    }
    
    /// **Using tesseract ocr to translate your image to words**
    func ocrTrans(yourImg:UIImage?)->String{
        var tempStr=""
        if yourImg != nil{
            let tesseract:G8Tesseract = G8Tesseract(language:"eng") // Previously support english translation.
            tesseract.language = "eng" //We can add traineddata file to tessdata folder.
            //tesseract.delegate = self as! G8TesseractDelegate
            //tesseract.charWhitelist = "01234567890"
            tesseract.image = yourImg
            tesseract.recognize()
            NSLog("%@", tesseract.recognizedText)
            tempStr=String(tesseract.recognizedText)
        }
        return tempStr
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
    /// Split string into tokens
    func splitString(yourStr:String)->[String]{
        var tokens:[String]=[]
        var tempToken:String=""
        for s_cha in yourStr.characters{
            if s_cha != " "{
                tempToken.append(s_cha)
            }
            else{
                if (tempToken != ""){
                    tokens.append(tempToken)
                }
                tempToken=""
            }
        }
        if tempToken != ""{
            tokens.append(tempToken)
            tempToken=""
        }
        return tokens
    }
    
}
