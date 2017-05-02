//
//  ToolOCRViewController.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/7.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/12 Implement the basic function for OCR&Split
//--------------------------------------------------------------
import UIKit
import Photos
import SnapKit
class ToolOCRViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var CollectionViewBigBang: UICollectionView!
    var cameraPicker: UIImagePickerController!
    var photoPicker: UIImagePickerController!
    var preImage:UIImage?
    var tokens:[String]=[]
    var num=0
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        //在view中添加控件activityIndicator
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.CollectionViewBigBang.delegate=self
        self.CollectionViewBigBang.dataSource=self
        if self.tokens.count != 0{
        self.createCollectionCells()
        }
        if self.preImage != nil{
            let tempTrs=TransFeatures()
            let resultStr=tempTrs.ocrTrans(yourImg: self.preImage)
            let tempFeature=TransFeatures()
            self.tokens = tempFeature.splitString(yourStr: resultStr)
            self.createCollectionCells()
            self.preImage = nil
        }
    }
    func dismissView(){
    self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SelectAll(_ sender: UIButton) {
        let numOfCell = self.CollectionViewBigBang.numberOfItems(inSection: 0)
        var indexPath:IndexPath?
        var cell:UICollectionViewCell?
        for index in 0..<numOfCell{
            indexPath = IndexPath(row:index,section:0)
            cell = self.CollectionViewBigBang.cellForItem(at: indexPath!)
            cell?.backgroundColor = UIColor(red: 193/255, green: 255/255, blue: 255/255, alpha: 1)
        }
    }
    @IBAction func CopyTokens(_ sender: UIButton) {
        let copyStr = self.countToken()
        var alert:UIAlertController
            UIPasteboard.general.string=copyStr
            alert = UIAlertController.init(title: "Note:", message: "The tokens have been copied.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: {
            action in
            self.dismissView()
        }))
        self.present(alert, animated: true)
    }
    func countToken()->String{
        var tempStr=""
        let numOfCell = self.CollectionViewBigBang.numberOfItems(inSection: 0)
        var indexPath:IndexPath?
        var cell:UICollectionViewCell?
        for index in 0..<numOfCell{
            indexPath = IndexPath(row:index,section:0)
            cell = self.CollectionViewBigBang.cellForItem(at: indexPath!)
            if cell?.backgroundColor == UIColor(red: 193/255, green: 255/255, blue: 255/255, alpha: 1){
                tempStr.append(tokens[index]+" ")
            }
        }
        return tempStr
    }
    func createCollectionCells(){
        var indexPath:IndexPath?
        var index:Int?
        self.num=0
        for _ in self.tokens{
            index=self.CollectionViewBigBang.numberOfItems(inSection: 0)
                        self.num+=1
            indexPath = IndexPath(row:index!,section:0)
            self.CollectionViewBigBang.insertItems(at: [indexPath!])
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.CollectionViewBigBang.cellForItem(at: indexPath)?.backgroundColor != UIColor(red: 193/255, green: 255/255, blue: 255/255, alpha: 1){
            self.CollectionViewBigBang.cellForItem(at: indexPath)?.backgroundColor=UIColor(red: 193/255, green: 255/255, blue: 255/255, alpha: 1)
        }else{
            self.CollectionViewBigBang.cellForItem(at: indexPath)?.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.num
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let tempCell = self.CollectionViewBigBang.dequeueReusableCell(withReuseIdentifier: "OcrCell", for: indexPath) as! ToolOCRCellController
        tempCell.wordLabel.text = self.tokens[indexPath.row]
        //tempCell.frame.size = CGSize(width: 200, height: 36)
        return tempCell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    @IBAction func SelectPhoto(_ sender: UIButton) {
        //
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            self.activityIndicator.startAnimating()
            //
            let picker = UIImagePickerController()
            //
            picker.delegate = self
            //
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("Error")
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print(info)
        self.num=0
        self.tokens=[]
        self.CollectionViewBigBang.reloadData()
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage        //图片控制器退出
        
        picker.dismiss(animated: true, completion: {
            () -> Void in
            let tempTrs=TransFeatures()
            let resultStr=tempTrs.ocrTrans(yourImg: image)
            print(resultStr)
            let tempFeature=TransFeatures()
            self.tokens = tempFeature.splitString(yourStr: resultStr)
            self.createCollectionCells()
            self.activityIndicator.stopAnimating()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        self.activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
