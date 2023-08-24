//
//  SoundPlayer.swift
//  tmchat
//
//  Created by Farid Guliev on 24.08.2023.
//

import Foundation
import AVFoundation

final class SoundPlayer {

    static let shared = SoundPlayer()

//    private var audioPlayer: AVAudioPlayer?

    func startRingtone() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(1005)
    }

    func stopRingtone() {
//        audioPlayer?.stop()
//        audioPlayer = nil
    }
}
