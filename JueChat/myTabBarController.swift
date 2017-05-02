//
//  myTabBarController.swift
//  JueChat
//
//  Created by Jue Wang on 2017/3/12.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  Set the style of tab bar controller and prepare for changing layout style and color
//  (not implemented now)
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 3/23 Implement the tab bar
//--------------------------------------------------------------
import UIKit

/// Map for storing styles of application
var appStyleMap = ["Default" : [UIColor.white,UIColor.gray,UIColor.blue]
                    ,"Night" : [UIColor.orange,UIColor.black,UIColor.black]]

/// Save the current/default style in tuple
var currentStyle = ("Default",appStyleMap["Default"])
class myTabBarController:UITabBarController{
    
    /// Instance of tab bar
    @IBOutlet private weak var TabBarMain: UITabBar!
    
    /// get set for the TabBar items' color
    var tabItemColor:UIColor{
        get{
            return TabBarMain.tintColor
        }
        set{
            TabBarMain.tintColor=newValue
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkStyle()
    }
    
    func checkStyle(){
            //tabItemColor = currentStyle.1![2]
    }
    
}
