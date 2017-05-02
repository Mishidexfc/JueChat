//
//  ToolsView.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/5.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//

import UIKit
import SnapKit
class ToolsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate{
    var tableView:UITableView?
    let toolModel=ToolsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView()
        self.tableView?.register(UINib(nibName:"ToolCell",bundle:nil), forCellReuseIdentifier: "ToolCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints{(make)->Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toolModel.toolList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ToolCellController=self.tableView?.dequeueReusableCell(withIdentifier: "ToolCell", for: indexPath) as! ToolCellController
        //cell.selectionStyle = .none
        cell.ToolTitleLabel.text = self.toolModel.toolList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toolName=self.toolModel.toolList[indexPath.row]
        switch toolName{
        case "Translation View":
            self.goTranslationView()
            break
        case "Image To Text":
            self.goOCR()
            break
        default:
            break
        }
        self.tableView?.deselectRow(at: indexPath, animated: true)
    }
    
    func goTranslationView(){
        let storyboard = UIStoryboard(name: "TranslationView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TranslationView")
        vc.title="Youdao Translation for JueChat"
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
    
    func goOCR(){
        let storyboard = UIStoryboard(name: "ToolOCR", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ToolOCRmain")
        vc.title="Tesseract OCR for JueChat"
        self.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed=false
    }
}
