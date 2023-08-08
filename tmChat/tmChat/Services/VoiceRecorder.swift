//
//  VoiceRecorder.swift
//  tmchat
//
//  Created by Shirin on 3/17/23.
//

import Foundation
import AVFAudio

class VoiceRecorder: NSObject, AVAudioRecorderDelegate {
    
    static let shared = VoiceRecorder()

    private var recordingSession = AVAudioSession.sharedInstance()
    private var audioRecorder: AVAudioRecorder?
    
    private var recordedAudioUrl: URL?
    private var recordedAuidioData: Data?
    private var recordedAuidioDuration: Int64?
    
//    func recordPermission() -> AVAudioSession.RecordPermission {
//        return recordingSession.recordPermission
//    }
//    
//    func requestPermissionForAudio() {
//        recordingSession.requestRecordPermission() { allowed in
//        }
//    }
//    
    func startRecording() {
        VoicePlayer.shared.pausePlayer()
        
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true, options: [])
            try recordingSession.overrideOutputAudioPort(.speaker)
        } catch {
            print("Set Recording Session")
            debugPrint(error)
        }

        recordedAudioUrl = getDocumentsDirectory().appendingPathComponent(UUID().uuidString+".m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
        ]
        
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordedAudioUrl!, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            audioRecorder?.prepareToRecord()

        } catch {
            print("Start Recording")
            debugPrint(error)
        }
    }
    
    func stopRecording(toCancel: Bool) -> VoiceRecordResult? {
        recordedAuidioDuration = Int64( audioRecorder?.currentTime ?? 0)
        audioRecorder?.stop()
        audioRecorder = nil

        if toCancel {
            deleteRecordedVoice(path: recordedAudioUrl?.path ?? "")
            return nil
        }

        do {
            guard let recordedAudioUrl = recordedAudioUrl else { return nil }
            let data = try Data(contentsOf: recordedAudioUrl)
            recordedAuidioData = data
            try data.write(to: recordedAudioUrl)
            
        } catch {
            print("Stop Recording")
            debugPrint(error)
            return nil
        }
        
        return VoiceRecordResult(url: recordedAudioUrl,
                                 duration: recordedAuidioDuration,
                                 data: recordedAuidioData)
    }
    
    func deleteRecordedVoice(path: String){
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("Could not delete voice")
                debugPrint(error)
            }
        }
    }
    
    class func deleteSong(_ atUrl: String){
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


extension FileManager {
    func getDocDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
