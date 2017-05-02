//
//  ChatDetailVoiceCell.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/19.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  the image detail when tap the image in the message.
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/19 Create file
//  Version 1.1 4/30 Implement the voice cell
//  Version 1.2 5/1  Implement the voice recording and playing
//--------------------------------------------------------------

import UIKit
import AVFoundation
import MediaPlayer
import SnapKit
class ChatDetailVoiceCell:UITableViewCell{
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var VoiceBubbleImage: UIImageView!
    @IBOutlet weak var voiceTimeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    var selectionCallback: [(() -> Void)]?
    var audioPlayer: AVAudioPlayer?
    var fileSingleName:String? // backup for the file path.
    var timer:Timer?
    var imageIndex:Int=0
    var whichSide:Bool=true
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func prepareStyle(whichSide:Bool){
        if whichSide{
        self.VoiceBubbleImage.layer.borderColor=UIColor.lightGray.cgColor
            self.VoiceBubbleImage.backgroundColor=UIColor.white
            self.VoiceBubbleImage.contentMode = .left
        }
        else{
            self.VoiceBubbleImage.layer.borderColor=UIColor.white.cgColor
            self.VoiceBubbleImage.backgroundColor=UIColor.init(red: 0.43, green: 0.62, blue: 0.92, alpha: 1.0)
            self.VoiceBubbleImage.contentMode = .right
            
        }
        self.VoiceBubbleImage.layer.cornerRadius=5
        self.VoiceBubbleImage.layer.borderWidth=0.5
        self.VoiceBubbleImage.clipsToBounds=true
        let tap=UITapGestureRecognizer(target: self, action: #selector(self.playVoice(_:)))
        tap.delegate = self
        self.VoiceBubbleImage.isUserInteractionEnabled = true
        self.VoiceBubbleImage.addGestureRecognizer(tap)
    }
    func drawLayout(whichSide:Bool,fileName:String){
        self.whichSide=whichSide
        self.fileSingleName=fileName
        self.preparePlay(filename: self.fileSingleName!)
        self.prepareStyle(whichSide: whichSide)
        if whichSide{//left side from other
            self.VoiceBubbleImage.image=UIImage(named: "ReceiverVoiceNodePlaying003")
            self.avatarImage.snp.removeConstraints()
            self.avatarImage.snp.makeConstraints{(make) -> Void in
                make.left.equalTo(10)
                make.top.equalTo(5)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            self.userNameLabel.snp.removeConstraints()
            self.userNameLabel.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(20)
                make.right.lessThanOrEqualTo(-200)
                //make.width.greaterThanOrEqualTo(45)
                make.left.equalTo(60)
                make.top.equalTo(self.contentView.snp.top).offset(5)
            }
            self.VoiceBubbleImage.snp.removeConstraints()
            self.VoiceBubbleImage.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(30)
                make.left.equalTo(60)
                make.top.equalTo(30)
                make.width.equalTo(100)
                make.bottom.equalTo(-12)
            }
            self.voiceTimeLabel.snp.removeConstraints()
            self.voiceTimeLabel.snp.makeConstraints{(make)->Void in
                make.left.equalTo(170)
                make.top.equalTo(35)
                make.height.equalTo(20)
                make.width.greaterThanOrEqualTo(20)
            }
        }
        else{//right side from myself
            self.VoiceBubbleImage.image=UIImage(named: "SenderVoiceNodePlaying003")
            self.avatarImage.snp.removeConstraints()
            self.avatarImage.snp.makeConstraints{(make) -> Void in
                make.right.equalTo(-10)
                make.top.equalTo(5)
                make.width.equalTo(45)
                make.height.equalTo(45)
            }
            self.userNameLabel.snp.removeConstraints()
            self.userNameLabel.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(20)
                //make.width.greaterThanOrEqualTo(45)
                make.right.equalTo(-60)
                make.top.equalTo(self.contentView.snp.top).offset(5)
            }
            self.VoiceBubbleImage.snp.removeConstraints()
            self.VoiceBubbleImage.snp.makeConstraints{(make) -> Void in
                make.height.equalTo(30)
                make.right.equalTo(-60)
                make.top.equalTo(30)
                make.width.equalTo(100)
                make.bottom.equalTo(-12)
            }
            self.voiceTimeLabel.snp.removeConstraints()
            self.voiceTimeLabel.snp.makeConstraints{(make)->Void in
                make.right.equalTo(-170)
                make.top.equalTo(35)
                make.height.equalTo(20)
                make.width.greaterThanOrEqualTo(20)
            }
        }
    }
    
    /// prepare for playing the file
    func preparePlay(filename:String){
        var path:String?
        if filename.contains(".m4a"){
            path=filename
        }
        else{
            path = Bundle.main.path(forResource: self.fileSingleName!, ofType: "wav")
            if !FileManager.default.fileExists(atPath: path!){
                
                path=NSHomeDirectory() + "/Documents/"+self.fileSingleName!+".wav"
            }
        }
        //If the file exists.
        let pathURL=URL(fileURLWithPath: path!)
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: pathURL)
        } catch {
            self.audioPlayer = nil
        }
        self.audioPlayer?.prepareToPlay()
        let audioTimeSec=NSInteger((self.audioPlayer?.duration)!)
        self.voiceTimeLabel.text = audioTimeSec.description + "s"
        self.audioPlayer?.stop()
    }
    
    /// Tap the voice bubble.
    func playVoice(_ sender:UIGestureRecognizer){
        var fileName=""
        if self.whichSide{
        fileName="ReceiverVoiceNodePlaying003"
        }
        else{
            fileName="SenderVoiceNodePlaying003"

        }
        if sender.state == .ended{
            if (self.audioPlayer?.isPlaying)!{
                self.audioPlayer?.stop()
                self.audioPlayer?.currentTime=0
                self.timer?.invalidate()
                self.VoiceBubbleImage.image=UIImage(named: fileName)
                self.imageIndex=0
            }
            else{
                self.imageIndex=0
                self.audioPlayer?.play()
                self.timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.changeVoiceImage), userInfo: nil, repeats: true)
                
            }
        }
        else{
            
        }
    }
    
    /// Change the image like animation when playing.
    func changeVoiceImage(){
        var fileShortName=""
        if self.whichSide{
            fileShortName="ReceiverVoiceNodePlaying00"
        }
        else{
            fileShortName="SenderVoiceNodePlaying00"
            
        }
        if(!(self.audioPlayer?.isPlaying)!){
            self.timer?.invalidate()
            self.VoiceBubbleImage.image=UIImage(named: fileShortName+"3")
            self.imageIndex=0
        }
        if self.imageIndex<3{
            self.imageIndex+=1
            let fileName=fileShortName+(self.imageIndex+1).description
            self.VoiceBubbleImage.image=UIImage(named: fileName)
        }
        else{
            self.imageIndex=0
            let fileName=fileShortName+(self.imageIndex+1).description
            self.VoiceBubbleImage.image=UIImage(named: fileName)
        }
    }
}
