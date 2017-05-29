//
//  ChatDetailBottomBar.swift
//  JueChat
//
//  Created by Jue Wang on 2017/4/12.
//  Copyright © 2017年 Syracuse University. All rights reserved.
//--------------------------------------------------------------
//  Description:
//  The bottom tool bar for CHatDetailView
//--------------------------------------------------------------
//  Update history:
//  Version 1.0 4/12 Create file
//--------------------------------------------------------------

import UIKit
import SnapKit
import AVFoundation
import MediaPlayer
class ChatDetailBottomBar:UIView, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    var emojiKeyBoard:ChatDetailEmojiPanel?
    var audioRecorder:AVAudioRecorder?
    let audioSession = AVAudioSession.sharedInstance()
    var aacPath:String?
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),
        AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
        AVNumberOfChannelsKey : NSNumber(value: 1),
        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
    var isAllowed:Bool = false // If the device allows using mic.
    @IBOutlet weak var InputTextField: UITextView!
    @IBOutlet weak var MoreFeatureButton: UIButton!
    @IBOutlet weak var EmojiButton: UIButton!
    @IBOutlet weak var VoiceRecordButton: UIButton!
    @IBOutlet weak var VoiceSwitchButton: UIButton!
    var parentInstance:ChatDetailView? // The other way to get the instance.
    var emojiPanelHeight:Int=200
    enum ChatKeyboardType: Int {
        case text, emoji, moreFeatures
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.VoiceRecordButton.isHidden=true
        self.drawLayout()
    }
    
    /// Draw the layout for bottom bar
    private func drawLayout(){
        self.VoiceRecordButton.layer.cornerRadius=5
        self.VoiceRecordButton.layer.borderWidth=0.5
        self.VoiceRecordButton.layer.borderColor=UIColor.init(red: 0.43, green: 0.62, blue: 0.92, alpha: 1.0).cgColor
        self.VoiceRecordButton.clipsToBounds=true
        let longpressRecord=UILongPressGestureRecognizer(target: self, action: #selector(self.startRecordVoice(_:)))
        audioSession.requestRecordPermission { (allowed) in
            if !allowed{
                self.isAllowed = false
            }else{
                self.isAllowed = true
                self.VoiceRecordButton.addGestureRecognizer(longpressRecord)
            }
        }
        if self.isAllowed{
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                //init
                try audioRecorder = AVAudioRecorder(url: self.directoryURL()!,settings: recordSettings)
                audioRecorder?.delegate = self as? AVAudioRecorderDelegate
                //prepare for record voice
                audioRecorder?.prepareToRecord()
            } catch let error as NSError{
                print(error)
            }
        }
        
    }
    
    private func directoryURL() -> URL? {
        // name an url for saving the record.
        let currentDateTime = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        //
        let recordingName = formatter.string(from: currentDateTime as Date)+".m4a"
        //let recordingName = formatter.string(from: currentDateTime as Date)+".wav"
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent(recordingName)
        self.aacPath = NSHomeDirectory() + "/Documents/"+recordingName
        return soundURL
    }
    
    /// long press the record button
    func startRecordVoice(_ sender:UILongPressGestureRecognizer){
        if let parentView = self.parentInstance{ // press down
            if sender.state == .began{
                parentView.recordImg?.isHidden=false
                self.recordLaunch()
            }
            else if sender.state == .ended{ // press up
                parentView.recordImg?.isHidden=true
                self.recordFinish()
            }
        }
        
    }
    func recordLaunch(){

        // If is recording
        if !(self.audioRecorder?.isRecording)! {
            do {
                try self.audioSession.setActive(true)
                self.audioRecorder?.record()
            }catch let error as NSError{
                print(error)
            }
        }
    }
    func recordFinish(){
        if (audioRecorder?.isRecording)!{
            audioRecorder?.stop()
            let usrModel=userInfo()
            let myModel=usrModel.getUserInfo()
            myModel.lastMsgType="voice"
            myModel.lastMsg=self.aacPath
            self.parentInstance?.chatSource.append(myModel)
            let cellPath=IndexPath(row: (self.parentInstance?.chatSource.count)!-1, section: 0)
            self.parentInstance?.chatDetailTable?.insertRows(at: [cellPath], with: .bottom)
            let secon = 0
            let rows = (self.parentInstance?.chatSource.count)!-1
            let indexPath = IndexPath(row: rows, section: secon)
            self.parentInstance?.chatDetailTable?.scrollToRow(at: indexPath, at:.bottom, animated: false)
            do {
                try audioSession.setActive(false)
            } catch let error as NSError{
                print(error)
            }
        }
    }
    
    /// When tap the left switch button for text or recording voice.
    @IBAction func SwitchInput(_ sender: UIButton) {
        if VoiceRecordButton.isHidden{
            VoiceRecordButton.isHidden=false
            self.VoiceSwitchButton.setImage(UIImage(named: "tool_keyboard_1"), for: .normal)
        }
        else{
            VoiceRecordButton.isHidden=true
            self.VoiceSwitchButton.setImage(UIImage(named: "tool_voice_1"), for: .normal)
        }
    }
    
    /// Show/Hide Emoji keyboard.
    @IBAction func TapEmojiBtn(_ sender: UIButton) {
        self.emojiKeyBoard?.superview?.endEditing(true)
        if self.emojiKeyBoard?.isHidden==true{
            self.emojiKeyBoard?.isHidden=false
            UIView.animate(withDuration: 0.3){
                self.emojiKeyBoard?.snp.updateConstraints{(make)->Void in
                    make.bottom.equalTo(0)
                }
                self.snp.updateConstraints{(make)->Void in
                    make.bottom.equalTo(-self.emojiPanelHeight)
                }
                self.emojiKeyBoard?.superview?.layoutIfNeeded()
            }
        }
        else{
            self.emojiKeyBoard?.isHidden=false
            UIView.animate(withDuration: 0.3){
                self.emojiKeyBoard?.snp.updateConstraints{(make)->Void in
                    make.bottom.equalTo(self.emojiPanelHeight)
                }
                self.snp.updateConstraints{(make)->Void in
                    make.bottom.equalTo(0)
                }
                self.emojiKeyBoard?.superview?.layoutIfNeeded()
            }
            self.emojiKeyBoard?.isHidden=true
        }
    }
    @IBAction func TapPlusButton(_ sender: UIButton) {
        //
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //
            let picker = UIImagePickerController()
            //
            picker.delegate = self
            //
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //
            self.parentInstance?.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        //查看info对象
        print(info)
        
        //显示的图片
         let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
            self.insertImgCell(yourImg: image)
        })
    }
    func insertImgCell(yourImg:UIImage){
        let userModel=userInfo().getUserInfo()
        userModel.lastMsgType="image"
        userModel.image = yourImg
        self.parentInstance?.chatSource.append(userModel)
        let cellPath=IndexPath(row: (self.parentInstance?.chatSource.count)!-1, section: 0)
        self.parentInstance?.chatDetailTable?.insertRows(at: [cellPath], with: .bottom)
        let secon = 0
        let rows = (self.parentInstance?.chatSource.count)!-1
        let indexPath = IndexPath(row: rows, section: secon)
        self.parentInstance?.chatDetailTable?.scrollToRow(at: indexPath, at:.bottom, animated: false)
        
    }
}
