//
//  VoiceMsgTbCell.swift
//  tmchat
//
//  Created by Shirin on 4/11/23.
//

import UIKit
import Alamofire

class VoiceMsgTbCell: MsgTbCell {

    static let id = "VoiceMsgTbCell"

    var content = VoiceMsgContentView()
    
    var isPlaying = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        content.voiceStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupData(message: Message) {
        content.duration.text = message.duration?.getMinSec()
        content.progressBar.maximumValue = Float(message.duration ?? 0)
        msgView.addMsgContentView(isOwn: message.senderUUID == AccUserDefaults.id,
                                  content: content)
        
        super.setupData(message: message)
    }
        
    @objc func click() {
        print(isPlaying)
        if isPlaying == true {
            VoicePlayer.shared.pausePlayer()
            
        } else {
            VoicePlayer.shared.endPlayer()
            VoicePlayer.shared.currentVoiceCell = self

            let url = FileManager.default.getDocDir().appendingPathComponent(message.content)
            if !(message.localPath ?? "").isEmpty
                && FileManager.default.fileExists(atPath: url.path)  {
                content.progress.isAnimating = false
                VoicePlayer.shared.playVoiceWithUrl(url: url,
                                                    id: message.id ?? 0)
            } else {
                downloadFile(filename: message.content, url: message.fileUrl ?? "")
            }
        }
        
        isPlaying = !isPlaying
        print("qqq ", isPlaying)
//        messageView.playPauseBtn.image =  UIImage(named: messageView.isPlaying == true ?  "pauseVoice" : "playVoice")?.withRenderingMode(.alwaysTemplate)
    }
    
    func downloadFile(filename: String, url: String) {
        content.icon.image = nil
        content.progress.isAnimating = true

        let destinationUrl = FileManager.default.getDocDir()
                                        .appendingPathComponent(filename)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            content.progress.isAnimating = false
            VoicePlayer.shared.playVoiceWithUrl(url: destinationUrl,
                                                id: message?.id ?? 0)
        } else {
            
            let destination: DownloadRequest.Destination = { _, _ in
                return (destinationUrl, [.removePreviousFile,
                                         .createIntermediateDirectories])
            }

            AF.download(URL(string: url)!, to: destination).response { response in
                print("AF.download endd")
                if response.error == nil {
                    self.content.progress.isAnimating = false
                    VoicePlayer.shared.playVoiceWithUrl(url: destinationUrl, id: self.message?.id ?? 0)
                }
            }
        }
    }
}
