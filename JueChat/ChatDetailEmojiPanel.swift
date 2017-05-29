//
//  ChatDetailBottomPanel.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/27.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  emoji keyboard for chat detail view
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/27 Create file
//--------------------------------------------------------------

import UIKit
class ChatDetailEmojiPanel:UIView,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate{
    fileprivate let numOfEmojiInRow:Int=8
    fileprivate let numOfEmojiInOnePage:Int=23
    var imageSource:[ChatEmojiModel]=[]
    var parentInstance:ChatDetailView?
    var isused:Bool=false
    @IBOutlet weak var EmojiCollectionView: UICollectionView!
    @IBOutlet weak var emojiPageControl: UIPageControl!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.drawLayout()
    }
    
    private func drawLayout(){
        self.EmojiCollectionView.register(UINib(nibName:"ChatDetailEmoji",bundle:nil), forCellWithReuseIdentifier: "EmojiCell")
        self.EmojiCollectionView.delegate=self
        self.EmojiCollectionView.dataSource=self
        let ExpressionPlist = Bundle.main.path(forResource: "Expression", ofType: "plist")
        let emojiArray = NSArray(contentsOfFile: ExpressionPlist!)
        for data in emojiArray! {
            let model = ChatEmojiModel.init(fromDictionary: data as! NSDictionary)
            self.imageSource.append(model)
        }
        let layout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize=CGSize(width: 32, height: 32)
        layout.minimumLineSpacing=10
        layout.minimumInteritemSpacing=20
        layout.sectionInset=UIEdgeInsetsMake(0,10,0,10)
        self.EmojiCollectionView.collectionViewLayout=layout
        self.EmojiCollectionView.isPagingEnabled=true
        self.EmojiCollectionView.showsHorizontalScrollIndicator=false
        self.emojiPageControl.numberOfPages=self.EmojiCollectionView.numberOfSections-1
        self.EmojiCollectionView.reloadData()
    }
}
extension ChatDetailEmojiPanel{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (self.imageSource.count % self.numOfEmojiInOnePage == 0 && self.imageSource.count != 0){
            return self.imageSource.count/self.numOfEmojiInOnePage
        }
        else{
            return self.imageSource.count/self.numOfEmojiInOnePage+1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.EmojiCollectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! ChatDetailEmoji
        if indexPath.row < collectionView.numberOfItems(inSection: indexPath.section)-1{
            let cellIndex=indexPath.section*self.numOfEmojiInOnePage+indexPath.row
            let ExpressionBundle = Bundle(url: Bundle.main.url(forResource: "Expression", withExtension: "bundle")!)
            cell.emojiImage.image = UIImage(named: self.imageSource[cellIndex+1].imageString, in: ExpressionBundle, compatibleWith: nil)
            let TapGes=UITapGestureRecognizer(target: self, action: #selector(self.handleEmojiSelect(_:)))
            cell.addGestureRecognizer(TapGes)
            cell.emojiStr = self.imageSource[cellIndex+1].text
            
        }
        else{
            let TapGes=UITapGestureRecognizer(target: self, action: #selector(self.handleCancelButtonTap(_:)))
            cell.addGestureRecognizer(TapGes)
            cell.emojiImage.image=UIImage(named:"emotion_delete")
        }
        cell.emojiImage.contentMode = .scaleToFill
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ((self.imageSource.count - section*self.numOfEmojiInOnePage)<self.numOfEmojiInOnePage){
            return self.numOfEmojiInOnePage-(section+1)*self.numOfEmojiInOnePage-self.imageSource.count+1
        }
        else{
            return self.numOfEmojiInOnePage+1
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isused==true{
            return
        }
        let pageWidth = scrollView.frame.size.width
        let page = (scrollView.contentOffset.x - pageWidth / 2 ) / pageWidth+1
        if(self.emojiPageControl.currentPage != Int(page)){
            self.emojiPageControl.currentPage = Int(page)
            self.isused=true
        }
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isused=false
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isused=false
    }
    
}
extension ChatDetailEmojiPanel{
    func handleEmojiSelect(_ sender:UITapGestureRecognizer){
        if sender.state == .ended{
            let cell = sender.view as! ChatDetailEmoji
            if let view = self.parentInstance{
                let textAttachment : NSTextAttachment = NSTextAttachment()
                var attributedStrM : NSMutableAttributedString?
                textAttachment.image = cell.emojiImage.image
                textAttachment.bounds = CGRect(x: 0, y: -4, width: (view.bottomBar?.InputTextField.font!.lineHeight)!, height: (view.bottomBar?.InputTextField.font!.lineHeight)!)
                if  (view.bottomBar?.InputTextField.attributedText==nil){
                    attributedStrM = NSMutableAttributedString(string: "")
                }
                else{
                    attributedStrM = NSMutableAttributedString(attributedString: (view.bottomBar?.InputTextField.attributedText)!)
                }
                attributedStrM?.append(NSAttributedString(attachment: textAttachment))
                let textViewFont = UIFont.systemFont(ofSize: 14)
                attributedStrM?.addAttribute(NSFontAttributeName, value:textViewFont,range: NSMakeRange(0,(attributedStrM?.length)!))
                
                view.bottomBar?.InputTextField.attributedText=attributedStrM
                
                //view.bottomBar?.InputTextField.text?.append(cell.emojiStr!)
            }
        }
    }
    func handleCancelButtonTap(_ sender:UITapGestureRecognizer){
        
    }
}
