//
//  VoicePlayer.swift
//  tmchat
//
//  Created by Shirin on 3/17/23.
//

import Foundation
import AVFoundation
import UIKit

class VoicePlayer {
    
    static let shared = VoicePlayer()
    
    var oldVoiceCell: VoiceMsgTbCell?
    var currentVoiceCell: VoiceMsgTbCell?
    
    var timeObserverToken: Any?
    var player: AVPlayer!
    var isPlaying = false
    var currentStatus = false
    
    func playVoiceWithUrl(url: URL, id: Int64){
        print(url)

        configureAudioSession()
        if oldVoiceCell == currentVoiceCell && player != nil  {
            currentVoiceCell?.content.icon.image = UIImage(named: "pause-voice")
            player.play()
            return
        }
        
        if oldVoiceCell?.isPlaying == true {
            removePeriodicTimeObserver()
            oldVoiceCell?.isPlaying = false
            oldVoiceCell?.content.icon.image = UIImage(named: "play-voice")
        }
                
        currentVoiceCell?.content.icon.image = UIImage(named: "pause-voice")

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        addPeriodicTimeObserver()
        player?.play()
    }
    
    func endPlayer(){
        player?.pause()
        oldVoiceCell = currentVoiceCell
    }
    
    func pausePlayer(){
        if oldVoiceCell == nil { oldVoiceCell = currentVoiceCell }
        currentVoiceCell?.content.icon.image = UIImage(named: "play-voice")
        currentVoiceCell?.isPlaying = false
        player?.pause()
    }
    
    func addPeriodicTimeObserver() {
        addNotification()
        oldVoiceCell?.content.progressBar.value = 0
        oldVoiceCell?.content.progressBar.isUserInteractionEnabled = false
        currentVoiceCell?.content.progressBar.isUserInteractionEnabled = true

        let time = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            self?.currentVoiceCell?.content.progressBar.value = Float(time.seconds)
        }
    }

    func removePeriodicTimeObserver() {
        removeNotification()
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

    
    func addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(#selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }

    func clear(){
        removePeriodicTimeObserver()
        currentVoiceCell = nil
        oldVoiceCell = nil
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    func configureAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playAndRecord,
                                      mode: .default,
                                      options: .allowBluetooth)
        
        try? audioSession.setActive(true, options: [])

        let routePort: AVAudioSessionPortDescription? = audioSession.currentRoute.outputs.first
        
        let portType = routePort?.portType
        if let type = portType, type.rawValue == "Receiver" {
            try? audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } else {
            try? audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        }
    }

    @objc func playerDidFinishPlaying() {
        currentVoiceCell?.content.progressBar.value = 0
        oldVoiceCell = currentVoiceCell
        currentVoiceCell = nil
        if oldVoiceCell?.isPlaying == true {
            oldVoiceCell?.isPlaying = false
            oldVoiceCell?.content.icon.image =  UIImage(named: "play-voice")
        }
    }
}
