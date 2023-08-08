//
//  AVPlayer.swift
//  tmchat
//
//  Created by Shirin on 4/13/23.
//

import AVFoundation.AVPlayer

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

