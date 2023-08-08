//
//  DownloadService.swift
//  tmchat
//
//  Created by Shirin on 4/18/23.
//

import Foundation
import Alamofire

class DownloadService {
    
    static let shared = DownloadService()
    
    weak var view: MessagingView?
    
    var downloadingMsgIds: [Int64] = []
    
    func downloadFile(id: Int64, filename: String, url: String) {

        let destinationUrl = FileManager.default.getDocDir()
                                        .appendingPathComponent(filename)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            MessageTable.shared.updateLocalPath(id: id, localPath: destinationUrl.path)
            
        } else {
            downloadingMsgIds.append(id)
            
            let destination: DownloadRequest.Destination = { _, _ in
                return (destinationUrl, [.removePreviousFile,
                                         .createIntermediateDirectories])
            }
            
            AF.download(URL(string: url)!, to: destination).downloadProgress(closure: { progress in
                print(progress)
                
                guard let progressBar = self.view?.viewWithTag(Int(id)) as? CustomProgressView else { return }
                if progressBar.isAnimating == false {
                    DispatchQueue.main.async {
                        progressBar.isAnimating = true
                    }
                }

            }).response { response in
                print("AF.download endd")
                
                self.downloadingMsgIds.removeAll(where: {$0 == id })
                if response.error == nil {
                    MessageTable.shared.updateLocalPath(id: id, localPath: destinationUrl.path)
                }
            }
        }
    }

}
